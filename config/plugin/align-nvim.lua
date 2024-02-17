vim.keymap.set(
    'x',
    'aw',
    function()
        require('align').align_to_string({
            preview = true,
            regex = false,
        })
    end,
    NS
)