{ inputs, config, pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/programs/claude.nix
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
    inputs.asana-omnifocus-sync.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
