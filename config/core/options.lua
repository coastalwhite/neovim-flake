local cmd = vim.cmd
local indent = 4

local cache_dir = os.getenv("XDG_CACHE_HOME")
if cache_dir == "" or cache_dir == nil then
	cache_dir = os.getenv("HOME") .. "/.cache"
end

-- Syntax processing
-----------------------------------------
cmd [[ filetype plugin indent on ]] -- IDK...
-----------------------------------------

local options = {
	-- Buffer control
	-----------------------------------------
	autoread = true, -- Reload the buffer
	hidden = true, -- Keep buffers loaded in the background
	-----------------------------------------

	shell = "/bin/sh", -- Set the shell to use
	clipboard = "unnamed,unnamedplus", -- Use the OS clipboard by default

	title = true,
	titlestring = "%t",

    termguicolors = true,
	background = "dark",

	fileencoding = "utf-8",

	updatetime = 300, -- Faster cursor hold time

	-- Window Settings
	-----------------------------------------
	splitbelow = true,
	splitright = true,
	-----------------------------------------

	-- Command line options
	-----------------------------------------
	wildmenu = true, -- Enchance command-line completion
	-- Ignore files for command-line completion
	wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor",
	-----------------------------------------

	-- VIMRC
	-----------------------------------------
	secure = true, -- Only allow secure vimrc commands
	-----------------------------------------

	-- Cursor and scrolling
	-----------------------------------------
	cursorline = true, -- Hightlight current line
	scrolloff = 5, -- Start scrolling 5 lines before you reach bottom/top
	sidescrolloff = 5, -- Start scrolling 5 lines before you reach left/right
	startofline = false, -- Keep cursor at horizontal position

	mouse = "nv", -- Allow for mouse movement
	-----------------------------------------

	-- Matching brackets
	-----------------------------------------
	showmatch = true, -- Show the matching bracket when you mouse over one
	matchtime = 2, -- How many tenths of a second to blink
	-----------------------------------------

	-- Line Numbering
	-----------------------------------------
	number = true, -- Set line numbers
	relativenumber = true, -- Use relative numbers
	-----------------------------------------

	-- Search/replace options
	-----------------------------------------
	gdefault = true, -- Add the g flag to search/replace by default
	ignorecase = true, -- Ignore case while searching
	hlsearch = true, -- Highlight searches
	incsearch = true, -- Hightlight dynamically as we search
	-----------------------------------------

	-- Encoding and filter options
	-----------------------------------------
	binary = true, -- Don't add new lines at the end of file
	eol = false, -- ^
	-----------------------------------------

	-- Backups, swaps and undo-dirs
	-----------------------------------------
	backup = false, -- Remove backup files (we have git for that)
	swapfile = false, -- Remove swap files

	-- Add undo files and put them in the '~/.vimdid folder'
	undodir = cache_dir .. "/vimdid",
	undofile = true,
	-----------------------------------------

	-- Modelines
	-----------------------------------------
	modeline = true, -- All custom settings per file
	modelines = 4, -- For 4 lines at the start of a file
	-- e.g // vim: syntax=html:ts=8
	-- will set the syntax to html for this file and change the tabstop to 8
	-----------------------------------------

	-- Bells
	-----------------------------------------
	errorbells = false, -- No sounds on error
	visualbell = false, -- Remove visual errors
	timeoutlen = 500, -- Wait for 500ms before a sequence has to be completed
	-----------------------------------------

	-- Tabs
	-----------------------------------------
	expandtab = true, -- Use spaces instead of tabs
	smarttab = true, -- Be smart when using tabs

	-- 1 tab == 4 spaces
	shiftwidth = indent, -- Number of spaces to use for indentation
	tabstop = indent, -- Number of spaces to use for a tab

	autoindent = true, -- Use the same indent as the last line
	smartindent = true, -- Smartly indent with new scopes/blocks
	-----------------------------------------

	-- Wrapping
	-----------------------------------------
	textwidth = 80, -- Attempt to have lines of 80 characters long
	colorcolumn = "+1", -- Set colored cell character after textwidth

	wrap = false, -- Don't wrap
	-----------------------------------------

	-- Folding
	-----------------------------------------
	foldenable = false, -- Don't do folding
	-----------------------------------------
}

for k, v in pairs(options) do
	vim.opt[k] = v
end