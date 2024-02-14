local cmd = vim.api.nvim_exec

-- Avoid mistyping
-----------------------------------------
cmd(
	[[
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Qa! qa!
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Wqa wqa
cnoreabbrev WQa wqa
cnoreabbrev Wa wa
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall
cnoreabbrev QA qa
]],
	false
)
-----------------------------------------