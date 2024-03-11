local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Automatically turn on spell check and wrap for text files
autocmd('FileType', {
    pattern = { 'markdown', 'typst', 'text', 'plaintex', 'gitcommit' },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true

        vim.opt_local.textwidth = 0
        vim.opt_local.colorcolumn = ''
    end
})

-- Automatically reload the buffer when it is changed from the outside
autocmd({ 'FocusGained' , 'BufEnter' }, { command = 'checktime' })

-- Add specific syntax for certain files
augroup('_filesyntaxes', { clear = true })
autocmd('BufReadPost', {
    group = '_filesyntaxes', 
    pattern = { 'gitconfig' },
    command = 'syntax=gitconfig',
})
autocmd('BufReadPost', {
    group = '_filesyntaxes', 
    pattern = { 'bashrc' },
    command = 'syntax=bash',
})
autocmd('BufReadPost', {
    group = '_filesyntaxes', 
    pattern = { 'zshrc' },
    command = 'syntax=zsh',
})

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost',  {
    group = 'YankHighlight',
    callback = function()
        vim.highlight.on_yank({
            higroup   = 'IncSearch',
            on_visual = false,
            timeout   = 500,
        })
    end
})

-- Open a file where you left off
augroup('_restore_view', { clear = true })
autocmd('BufWinLeave', { group = '_restore_view', command = 'silent! mkview'   })
autocmd('BufWinEnter', { group = '_restore_view', command = 'silent! loadview' })

-- Disabled color column within oil.nvim
autocmd('FileType', {
    pattern = 'oil',
    callback = function()
        vim.opt_local.colorcolumn = ''
    end,
})

-- Quick Fix Window
augroup('_quickfix', { clear = true })
autocmd('FileType', {
    group = '_quickfix',
    pattern = { 'qf', 'help', 'man', 'lspinfo' },
    callback = function()
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>close<CR>', opts)
    end,
})
autocmd('FileType', {
    group = '_quickfix',
    pattern = { 'qf' },
    command = 'set nobuflisted',
})