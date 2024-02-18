# NeoVIM Flake

This is [Nix Flake] that contains my [NeoVIM] setup.

## Usage

To run this, install the `nix` package manager and run the following
command:

```bash
nix run --experimental-features 'nix-command flakes' github:coastalwhite/neovim-flake
```

or you can add it as a Flake input to another flake.

[Nix Flake]: https://nixos.wiki/wiki/Flakes
[NeoVIM]: https://neovim.io/