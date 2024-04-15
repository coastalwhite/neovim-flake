# vim: ft=lua
{ pkgs }:
let
  rust-bin = pkgs.rust-bin.stable.latest;
in
''
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

vim.cmd [[
" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! link CmpItemKindInterface CmpItemKindVariable
highlight! link CmpItemKindText CmpItemKindVariable
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! link CmpItemKindMethod CmpItemKindFunction
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! link CmpItemKindProperty CmpItemKindKeyword
highlight! link CmpItemKindUnit CmpItemKindKeyword
]]

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
	return
end

local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"

cmp.setup({
	snippet = { 
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},
	mapping = {
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item()),
		['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item()),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer",  max_item_count = 3 },
		{ name = "path",    max_item_count = 3 },
		{ name = "luasnip", max_item_count = 3 },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})

-- Disallow from focussing the signature help windo
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { focusable = false }
)

-- Fix the underline highlighting to not be undercurl
vim.cmd([[ " Underline the offending code
hi DiagnosticUnderlineError guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineWarn guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineInformation guifg=NONE ctermfg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineHint guifg=NONE ctermfg=NONE cterm=underline gui=underline
]])

function keymap(mode, keys, command, desc)
	vim.keymap.set(mode, keys, command, { noremap = true, silent = true, desc = desc })
end

local on_attach = function(client, bufnr)
	client.server_capabilities.semanticTokensProvider = nil
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities()
local flags = { debounce_text_changes = 150 }
local lspconfig = require("lspconfig")

-- Marksman (https://github.com/artempyanykh/marksman)
lspconfig.marksman.setup {
    cmd = { "${pkgs.marksman}/bin/marksman" },
}

-- rust_analyzer (https://rust-analyzer.github.io/)
lspconfig.rust_analyzer.setup({
  -- This allows us to use the environment supplied rust-analyzer when
  -- available, which prevents problems with incremental compilation.
	cmd = { "/bin/sh", "-c", "rust-analyzer || ${rust-bin.rust-analyzer}/bin/rust-analyzer" },
	on_attach = on_attach,
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "by_self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
				loadOutDirsFromCheck = true,
			},
			procMacro = {
				enable = true,
			},
		},
	},
	flags = flags,
	capabilities = capabilities,
})

-- texlab (https://texlab.netlify.app/)
lspconfig.texlab.setup({
    cmd = { "${pkgs.texlab}/bin/texlab" },
	on_attach = on_attach,
	flags = flags,
	capabilities = capabilities,
})

-- clangd (https://clangd.llvm.org/)
local clangd_capabilities = { offsetEncoding = { "utf-16" } }
for j, x in ipairs(capabilities) do
	clangd_capabilities[j] = x
end
lspconfig.clangd.setup({
    cmd = { "${pkgs.libclang}/bin/clangd" },
	on_attach = on_attach,
	flags = flags,
	capabilities = clangd_capabilities,
})

-- pyright (https://github.com/microsoft/pyright)
lspconfig.pyright.setup({
    cmd = { "${pkgs.nodePackages.pyright}/bin/pyright" },
	on_attach = on_attach,
	flags = flags,
	capabilities = capabilities,
})

lspconfig.nil_ls.setup({
    cmd = { "${pkgs.nil}/bin/nil" },
	on_attach = on_attach,
	flags = flags,
	capabilities = capabilities,
})

lspconfig.typst_lsp.setup({
    cmd = { "${pkgs.typst-lsp}/bin/typst-lsp" },
	on_attach = on_attach,
	flags = flags,
	capabilities = capabilities,
	settings = {
		exportPdf = "never",
	},
	root_dir = function(fname)
		return require('lspconfig.util').root_pattern('typst.toml', '.git')(fname)
			or vim.fn.getcwd()
	end,
})

lspconfig.denols.setup({
    cmd = { "${pkgs.deno}/bin/deno", "lsp" },
	on_attach = on_attach,
	flags = flags,
	capabilities = capabilities,
})
''