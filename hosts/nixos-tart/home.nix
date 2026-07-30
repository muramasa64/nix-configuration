{ config, pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/home-manager/base.nix
    ../../modules/home-manager/programs/niri.nix
  ];
  home.username = username;
  home.homeDirectory = "/home/${username}";
}
