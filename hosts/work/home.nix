{ config, pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/home-manager/common.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    awscli2
    claude-code
    duckdb
    gh
    lemminx
    utm
  ];
}
