{ pkgs }:
let
    concatLines = lines: builtins.concatStringsSep "\n" lines;
    createFile = f: n: pkgs.writeTextFile {
        name = n;
        text = import f { inherit pkgs; };
    };
    configs = [
        ./core/options.lua
        ./core/keymaps.lua
        ./core/autocommands.lua
        ./core/abbreviations.lua
        ./plugin/align-nvim.lua
        ./plugin/comment-nvim.lua
        ./plugin/gitsigns-nvim.lua
        ./plugin/mini-nvim.lua
        ./plugin/lualine-nvim.lua
        ./plugin/telescope-nvim.lua
        ./plugin/nvim-notify.lua
        ./plugin/oil-nvim.lua
        ./plugin/which-key-nvim.lua
        ./plugin/dressing-nvim.lua
        (createFile ./lsp.lua.nix "lsp.lua")
    ];
	sourceLines = builtins.map (f: "luafile ${f}") configs;
	vimRC = concatLines sourceLines;
in
	vimRC