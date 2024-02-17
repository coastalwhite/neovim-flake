{ pkgs, src }:
pkgs.vimUtils.buildVimPlugin {
  name = "align.nvim";
  inherit src;
}