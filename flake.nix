{
  description = "A flake with my NeoVim configuration";
  inputs = {
	  nixpkgs.url = "github:NixOS/nixpkgs";
	  neovim = {
		  url = "github:neovim/neovim/stable?dir=contrib";
		  inputs.nixpkgs.follows = "nixpkgs";
	  };
	  align-nvim-src = {
	    url = "github:Vonr/align.nvim";
		  flake = false;
	  };
  };
  outputs = { self, nixpkgs, neovim, align-nvim-src }: 
  let 
    system = "x86_64-linux";
    overlayFlakeInputs = prev: final: {
      neovim = neovim.packages.${system}.neovim;
      vimPlugins = final.vimPlugins // {
        align-nvim = import ./vimPlugins/align-nvim.nix {
          src = align-nvim-src;
          pkgs = prev;
        };
      };
    };

    overlayMyNeovim = prev: final: {
      myNeovim = let
        customRC = import ./config/vimrc.nix { inherit pkgs; };
        plugins = import ./config/plugins.nix { inherit pkgs; };
        runtimeDependencies = pkgs.symlinkJoin {
          name = "runtimeDependencies";
          paths = with pkgs; [
            xclip
          ];
        };
        wrappedNeovim = pkgs.wrapNeovim pkgs.neovim {
          configure = {
            inherit customRC;
            packages.all.start = plugins;
          };
        };
      in pkgs.writeShellApplication {
        name = "nvim";
        runtimeInputs = [ runtimeDependencies ];
        text = ''
          ${wrappedNeovim}/bin/nvim "$@"
        '';
      };
    };

    pkgs = import nixpkgs {
      inherit system;
      overlays = [ overlayFlakeInputs overlayMyNeovim ];
    };
  in {
	  packages.${system}.default = pkgs.myNeovim;
	  apps.${system}.default = {
		  type = "app";
		  program = "${pkgs.myNeovim}/bin/nvim";
	  };
  };
}
