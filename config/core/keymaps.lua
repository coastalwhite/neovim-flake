function keymap(mode, keys, command, desc)
    vim.keymap.set(mode, keys, command, {
        noremap = true,
        silent  = true,
        desc    = desc,
    })
end

-- Map leader to space
keymap('', '<Space>', '<Nop>', '')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Map Control-L to escape
keymap('', '<C-L>', '<Esc>', '')
keymap('i', '<C-L>', '<Esc>', '')

-- Motions
-----------------------------------------
-- Add a new line without going into insert mode
keymap('n', 'mo', '<cmd>:call append(line("."), repeat([""], v:count1))<CR>', 'Add an line below current line')
keymap('n', 'mO', '<cmd>:call append(line(".")-1, repeat([""], v:count1))<CR>', 'Add an line above current line')

-- movement by screen line instead of file line (for text wrap)
keymap('n', 'j', 'gj', '')
keymap('n', '<down>', 'gj', '')
keymap('n', 'k', 'gk', '')
keymap('n', '<up>', 'gk', '')
-----------------------------------------

keymap('n', 'gV', '`[v`]', 'Select last inserted text')

-- Moving between buffers
-----------------------------------------
keymap('n', '<Leader><Tab>',   ':b#<CR>',    'Move to last open buffer')
keymap('n', '<Leader><Right>', ':bnext<CR>', 'Move to next buffer')
keymap('n', '<Leader><Left>',  ':bprev<CR>', 'Move to previous buffer')
-----------------------------------------
-- Writing with Leader w
keymap('n', '<Leader>w', ':write<CR>', 'Save current buffer')

-- Toggling spell check
keymap('n', '<Leader>ss', ':setlocal spell!<CR>', 'Toggle spell checker')

-- Remove all highlights
keymap('n', '<Leader>hl', ':nohl<CR>', 'Remove all highlight')

-- Toggle show tabs and trailing spaces
keymap('n', '<Leader>c', function()
    vim.o.list = not vim.o.list
end, 'Toggle display of tabs and trailing spaces')

-- Turn off arrow-keys for movement
-----------------------------------------
for _, key in ipairs({ '<Up>', '<Down>', '<Left>', '<Right>' }) do
	keymap('n', key, '<Nop>', '')
	keymap('i', key, '<Nop>', '')
end
-----------------------------------------

-- Plugin specific keybindings
-----------------------------------------
-- LSP
keymap('n', '<Leader>ll', function() vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' }) end, 'Show diagnostic')
keymap('n', '<Leader>lq', vim.diagnostic.setloclist,                                                          'Add diagnostics to location list')
keymap('n', '[d',         vim.diagnostic.goto_prev,                                                           'Move to next diagnostic')
keymap('n', ']d',         vim.diagnostic.goto_next,                                                           'Move to previous diagnostic')
keymap('n', '<Leader>lD', vim.lsp.buf.declaration,                                                            'Goto declaration')
keymap('n', '<Leader>lR', vim.lsp.buf.rename,                                                                 'Rename symbol')
keymap('n', '<Leader>la', vim.lsp.buf.code_action,                                                            'Code actions')
keymap('n', 'K',          vim.lsp.buf.hover,                                                                  'Hover for symbol')
keymap('n', '<C-k>',      vim.lsp.buf.signature_help,                                                         'Signature help')
keymap('i', '<C-k>',      vim.lsp.buf.signature_help,                                                         'Signature help')
keymap('n', '<Leader>ld', function() require('telescope.builtin').lsp_definitions()                      end, 'Goto definitions')
keymap('n', '<Leader>li', function() require('telescope.builtin').lsp_implementations()                  end, 'Goto implementations')
keymap('n', '<Leader>lt', function() require('telescope.builtin').lsp_type_definitions()                 end, 'Goto type definitions')
keymap('n', '<Leader>lr', function() require('telescope.builtin').lsp_references()                       end, 'Goto reference')
keymap('n', '<Leader>ls', function() require('telescope.builtin').lsp_document_symbols()                 end, 'List document symbols')
keymap('n', '<Leader>lS', function() require('telescope.builtin').lsp_workspace_symbols()                end, 'List workspace symbols')
keymap('n', '<Leader>le', function() require('telescope.builtin').diagnostics()                          end, 'List diagnostics')


function buf_format()
    vim.lsp.buf.format({ async = true })
end

-- Formatting
keymap('n', '<Leader>lf', buf_format, 'Format buffer')

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

keymap('n', '<Leader>tt', toggle_inline_hints, 'Toggle inline diagnostic hints')

-- Fugative
keymap('n', '<Leader>gc', ':Git commit<CR>',    'Git commit')
keymap('n', '<Leader>gr', ':Git rebase -i<CR>', 'Git rebase')
keymap('n', '<Leader>gs', ':Git<CR>',           'Git status')
keymap('n', '<Leader>gm', ':Git mergetool<CR>', 'Git mergetool')
-----------------------------------------

