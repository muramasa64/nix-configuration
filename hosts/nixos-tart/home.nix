{ config, pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/home-manager/base.nix
  ];
  home.username = username;
  home.homeDirectory = "/home/${username}";
}
