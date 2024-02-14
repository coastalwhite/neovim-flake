local keymap = vim.keymap.set

function opts(desc)
    return {
        noremap = true,
        silent = true,
        desc = desc,
    }
end

local actions = require('telescope.actions')
local builtins = require('telescope.builtin')

require('telescope').setup {
    defaults = {
        mappings = { n = { ['q'] = actions.close } },
        file_ignore_patterns = { '.git/', 'target/' },
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        disable_devicons = true,
    },
}

keymap('n', 'z=',          builtins.spell_suggest, opts('Find spelling suggestion'))
keymap('n', '<leader>ff',  builtins.find_files,    opts('Find file'               ))
keymap('n', '<leader>fw',  builtins.live_grep,     opts('Find words'              ))
keymap('n', '<leader>fb',  builtins.buffers,       opts('Find buffers'            ))
keymap('n', '<leader>fh',  builtins.help_tags,     opts('Find help tags'          ))
keymap('n', '<leader>ft',  builtins.treesitter,    opts('Find treesitter'         ))
keymap('n', '<leader>fgb', builtins.git_branches,  opts('Find git branch'         ))
keymap('n', '<leader>fgc', builtins.git_commits,   opts('Find git commit'         ))
keymap('n', '<leader>fgC', builtins.git_bcommits,  opts('Find git buffer commit'  ))
keymap('n', '<leader>fgs', builtins.git_status,    opts('Find git status'         ))