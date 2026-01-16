{ config, pkgs, starship-jj-pkg, ... }:
{
  home.stateVersion = "25.11";
   home.username = "kazuhiko";
   home.homeDirectory = "/Users/kazuhiko";

  home.packages = with pkgs; [
    awscli2
    bash
    bat
    bitwarden-cli
    curl
    delta
    diffnav
    direnv
    duckdb
    eza
    fd
    fzf
    git
    hackgen-font
    hackgen-nf-font
    lua-language-server
    nix-direnv
    nix-output-monitor
    nixd
    nixfmt
    nushell
    nvd
    ripgrep
    saml2aws
    sd
    starship-jj-pkg
    tree-sitter
    udev-gothic
    udev-gothic-nf
  ];

  xdg.configFile = {
    "direnv".source = config/direnv;
    "starship-jj".source = config/starship-jj;
  };

  home.file.".config/karabiner" = {
    source = config/karabiner;
    recursive = true;
  };

  programs.home-manager.enable = true;

  imports = [
    ./programs/fish.nix
    ./programs/fzf.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/jj.nix
    ./programs/neovim.nix
    ./programs/starship.nix
  ];
}
