local keymap = vim.keymap.set
function opts(desc)
    return {
        noremap = true,
        silent = true,
        desc = desc,
    }
end

require('oil').setup {
    default_file_explorer = true,
    columns = { 'size' },
}

keymap('n', '<leader>-', '<CMD>Oil<CR>', opts('Open parent directory'))