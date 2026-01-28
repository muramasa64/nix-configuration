{ config, pkgs, starship-jj-pkg, ... }:
{
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";

  imports = [
    ./programs/fish.nix
    ./programs/fzf.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/jj.nix
    ./programs/neovim.nix
    ./programs/starship.nix
  ];

  home.packages = with pkgs; [
    bash
    bat
    bitwarden-cli
    curl
    delta
    diffnav
    direnv
    eza
    fd
    fzf
    git
    hackgen-font
    hackgen-nf-font
    mas
    nix-direnv
    nix-output-monitor
    nixd
    nixfmt
    nvd
    ripgrep
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
}
