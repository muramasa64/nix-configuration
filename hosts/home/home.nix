{ config, pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/home-manager/darwin.nix
  ];
  home.username = username;
  home.homeDirectory = "/Users/${username}";
}
