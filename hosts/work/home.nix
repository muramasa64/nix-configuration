{ config, pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/home-manager/common.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    awscli2
    devenv
    duckdb
    utm
  ];

  home.file = {
    ".pingcli/config.yml" = {
      source = config.lib.file.mkOutOfStoreSymlink ../../config/pingctl/config.yml;
    };
  };
}
