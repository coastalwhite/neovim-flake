require('gitsigns').setup {
    signs = {
        add = '│',
        change = '|',
        delete = '_',
        topdelete = '‾',
        changedelete = '~',
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc, opts)
            opts = opts or { silent = true, noremap = true, desc = desc }
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
			if vim.wo.diff then
				vim.cmd.normal({']c', bang = true})
			else
				gitsigns.nav_hunk('next')
			end
        end, "Move to next Git change", { expr = true })

        map('n', '[c', function()
			if vim.wo.diff then
        		vim.cmd.normal({'[c', bang = true})
      		else
        		gitsigns.nav_hunk('prev')
      		end
        end, "Move to previous Git change", { expr = true })

        -- Actions
        map({ 'n', 'v' }, '<leader>hs', gs.stage_hunk,                                 "Stage hovered Hunk"              )
        map({ 'n', 'v' }, '<leader>hr', gs.reset_hunk,                                 "Reset hovered Hunk"              )
        map('n',          '<leader>hS', gs.stage_buffer,                               "Stage buffer"                    )
        map('n',          '<leader>hu', gs.undo_stage_hunk,                            "Undo stage hovered hunk"         )
        map('n',          '<leader>hR', gs.reset_buffer,                               "Restore buffer"                  )
        map('n',          '<leader>hp', gs.preview_hunk,                               "Preview hunk"                    )
        map('n',          '<leader>hb', function() gs.blame_line({ full = true }) end, "Blame current line"              )
        map('n',          '<leader>hd', gs.diffthis,                                   "Delta this buffer"               )
        -- map('n',          '<leader>hD', function() gs.diffthis('~') end                                                  )
        map('n',          '<leader>tb', gs.toggle_current_line_blame,                  "Toggle line blame"               )
        map('n',          '<leader>td', gs.toggle_deleted,                             "Toggle showing the deleted hunks")

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    show_deleted = false,
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
    },
}