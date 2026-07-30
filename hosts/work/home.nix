{ inputs, config, pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/home-manager/darwin.nix
    ../../modules/home-manager/programs/claude.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.sessionVariables = {
    PIP_CERT = "/Library/Application Support/Netskope/STAgent/data/nscacert.pem";
  };

  home.packages = with pkgs; [
    awscli2
    claude-code
    duckdb
    gh
    lemminx
    tart
    utm
    inputs.asana-omnifocus-sync.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
