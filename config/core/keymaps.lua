local keymap = vim.keymap.set
function opts(desc)
	return {
		noremap = true,
		silent = true,
		desc = desc,
	}
end

-- Map leader to space
keymap("", "<Space>", "<Nop>", opts(''))

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Map Control-L to escape
keymap("", "<C-L>", "<Esc>", opts(''))
keymap("i", "<C-L>", "<Esc>", opts(''))

-- Motions
-----------------------------------------
-- Add a new line without going into insert mode
keymap("n", "mo", '<cmd>:call append(line("."), repeat([""], v:count1))<CR>', opts('Add an line below current line'))
keymap("n", "mO", '<cmd>:call append(line(".")-1, repeat([""], v:count1))<CR>', opts('Add an line above current line'))

-- movement by screen line instead of file line (for text wrap)
keymap("n", "j", "gj", opts(''))
keymap("n", "<down>", "gj", opts(''))
keymap("n", "k", "gk", opts(''))
keymap("n", "<up>", "gk", opts(''))
-----------------------------------------

keymap("n", "gV", "`[v`]", opts('Select last inserted text'))

-- Moving between buffers
-----------------------------------------
keymap("n", "<Leader><Tab>",   ":b#<CR>",    opts('Move to last open buffer'))
keymap("n", "<Leader><Right>", ":bnext<CR>", opts('Move to next buffer'))
keymap("n", "<Leader><Left>",  ":bprev<CR>", opts('Move to previous buffer'))
-----------------------------------------
-- Writing with Leader w
keymap("n", "<Leader>w", ":write<CR>", opts('Save current buffer'))

-- Toggling spell check
keymap("n", "<Leader>ss", ":setlocal spell!<CR>", opts('Toggle spell checker'))

-- Remove all highlights
keymap("n", "<Leader>hl", ":nohl<CR>", opts('Remove all highlight'))

-- Toggle show tabs and trailing spaces
keymap("n", "<Leader>c", ":set nolist!<CR>", opts('Toggle display of tabs and trailing spaces'))

-- Turn off arrow-keys for movement
-----------------------------------------
for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
	keymap("n", key, "<Nop>", opts(''))
	keymap("i", key, "<Nop>", opts(''))
end
-----------------------------------------

-- Plugin specific keybindings
-----------------------------------------
-- LSP
keymap("n", "<Leader>ll", vim.diagnostic.open_float, opts('Open diagnostic'))
keymap("n", "<Leader>lq", vim.diagnostic.setloclist, opts('Add diagnostics to location list'))
keymap("n", "[d", vim.diagnostic.goto_prev, opts('Move to next diagnostic'))
keymap("n", "]d", vim.diagnostic.goto_next, opts('Move to previous diagnostic'))

function buf_format()
    vim.lsp.buf.format({ async = true })
end

-- Formatting
keymap("n", "<Leader>lf", buf_format, opts('Format buffer'))

-- Create a keymap for toggling inline hints
vim.g.show_inline_hints = false -- Disable by default
vim.diagnostic.config({virtual_text = false})
function toggle_inline_hints()
    if vim.g.show_inline_hints then
        vim.g.show_inline_hints = false
        vim.diagnostic.config({virtual_text = false})
    else
        vim.g.show_inline_hints = true
        vim.diagnostic.config({virtual_text = true})
    end
end

keymap("n", "<Leader>tt", toggle_inline_hints, opts('Toggle inline diagnostic hints'))

-- Fugative
keymap("n", "<Leader>gc", ":Git commit<CR>",    opts('Git commit'))
keymap("n", "<Leader>gr", ":Git rebase -i<CR>", opts('Git rebase'))
keymap("n", "<Leader>gs", ":Git<CR>",           opts('Git status'))
keymap("n", "<Leader>gm", ":Git mergetool<CR>", opts('Git mergetool'))
-----------------------------------------
