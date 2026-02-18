{ inputs, config, pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";

  imports = [
    ./programs/direnv.nix
    ./programs/fish.nix
    ./programs/fzf.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/jj.nix
    ./programs/neovim.nix
    ./programs/starship.nix
  ];

  home.packages = with pkgs; [
    inputs.arto.packages.${system}.default
    inputs.starship-jj.packages.${system}.default
    bash
    bat
    bitwarden-cli
    curl
    delta
    devenv
    diffnav
    direnv
    eza
    fd
    fzf
    git
    hackgen-font
    hackgen-nf-font
    lua-language-server
    mas
    nix-output-monitor
    nixd
    nixfmt
    nvd
    ripgrep
    sd
    tree-sitter
    udev-gothic
    udev-gothic-nf
    vscode-json-languageserver
  ];

  xdg.configFile = {
    "starship-jj".source = ../../config/starship-jj;
  };

  home.file.".config/karabiner" = {
    source = ../../config/karabiner;
    recursive = true;
  };
}
