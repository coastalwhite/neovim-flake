{ pkgs }:
with pkgs.vimPlugins; [
  vim-rooter        # Move to project-level folder upon opening
  
  comment-nvim      # Comment out lines

  vim-repeat        # Repeat with the dot command for other plugins
  vim-surround      # Changing surrounding quotes, brackets or tags
  vim-fugitive      # Git Integration
  align-nvim        # Alignment

  typst-vim         # Syntax Highlighting for Typst

	mini-nvim         # Colorscheme
	nvim-notify       # Show notifications in the top right
  gitsigns-nvim     # Bar git status
	lualine-nvim      # Status line
	oil-nvim          # File picker
  which-key-nvim    #
	dressing-nvim     # Fancy UI
  telescope-nvim    #

  nvim-lspconfig
  nvim-cmp
  cmp-buffer
  cmp-path
  cmp-nvim-lsp

  luasnip           # snippet engine
  cmp_luasnip       # for autocompletion
  friendly-snippets # useful snippets

  nvim-dap
]