{ pkgs, src }:
pkgs.vimUtils.buildVimPlugin {
  name = "nvim-rooter.lua";
  inherit src;
}
