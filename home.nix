{ config, pkgs, ... }:
{
  home.stateVersion = "25.11";
  home.username = "kazuhiko";
  home.homeDirectory = "/Users/kazuhiko";

  xdg.configFile = {
    "karabiner".source = config/karabiner;
  };

  programs.home-manager.enable = true;
}
