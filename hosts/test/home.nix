{ config, pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/home-manager/common.nix
  ];
  home.username = username;
  home.homeDirectory = "/Users/${username}";
}
