{
  description = "A flake with my NeoVim configuration";
  inputs = {
	  nixpkgs.url = "github:NixOS/nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	  nvim-rooter-src = {
	    url = "github:notjedi/nvim-rooter.lua";
		  flake = false;
	  };
  };
  outputs = { self, nixpkgs, rust-overlay, nvim-rooter-src }: 
  let 
    system = "x86_64-linux";
    overlayFlakeInputs = prev: final: {
      vimPlugins = final.vimPlugins // {
        nvim-rooter-lua = import ./vimPlugins/nvim-rooter.nix {
          src = nvim-rooter-src;
          pkgs = prev;
        };
      };
			rust-analyzer-wrap = (import ./rust-analyzer { pkgs = prev; });
    };

    myNeovim = pkgs.neovim.override {
      configure = {
        customRC = import ./config/vimrc.nix { inherit pkgs; };
        packages.all.start = import ./config/plugins.nix { inherit pkgs; }; 
      };
    };
    overlayMyNeovim = prev: final: {
      nvim = pkgs.writeShellApplication {
        name = "nvim";
        runtimeInputs = [
          (pkgs.symlinkJoin {
            name = "runtimeDependencies";
            paths = with pkgs; [
              xclip
              (import ./rust-analyzer { inherit pkgs; })
            ];
          })
        ];
        text = ''
          ${myNeovim}/bin/nvim "$@"
        '';
      };
    };

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        rust-overlay.overlays.default
        overlayFlakeInputs
        overlayMyNeovim
      ];
    };
  in {
	  packages.${system}.default = pkgs.nvim;
	  apps.${system}.default = {
		  type = "app";
		  program = "${pkgs.nvim}/bin/nvim";
	  };
  };
}
