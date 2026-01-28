{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  programs.neovim = {
    enable = true;
  };

  xdg.configFile."nvim" = {
    source = mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles-nvim";
    recursive = true;
  };
}
