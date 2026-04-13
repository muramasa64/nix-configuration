{ inputs, config, pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";

  imports = [
    ./programs/arto.nix
    ./programs/direnv.nix
    ./programs/fish.nix
    ./programs/fzf.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/jj.nix
    ./programs/starship.nix
  ];

  home.packages = with pkgs; [
    inputs.starship-jj.packages.${system}.default
    bash
    bat
    bitwarden-cli
    curl
    delta
    devenv
    diffedit3
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
    neovim
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
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles-nvim";
  };

  home.file.".config/karabiner" = {
    source = ../../config/karabiner;
    recursive = true;
  };
}
