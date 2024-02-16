function keymap(mode, keys, command, desc)
    vim.keymap.set(mode, keys, command, {
        noremap = true,
        silent = true,
        desc = desc,
    })
end

require('oil').setup {
    default_file_explorer = true,
    columns = { 'size' },
}

keymap('n', '<leader>u', '<CMD>Oil<CR>', 'Open parent directory')