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
    curl
    delta
    devenv
    diffedit3
    diffnav
    eza
    fd
    fzf
    git
    jd-diff-patch
    lua-language-server
    mas
    neovim
    nix-output-monitor
    nixd
    nixfmt
    # nushell
    nvd
    ripgrep
    sd
    tree-sitter
    vscode-json-languageserver
  ];

  xdg.configFile = {
    "starship-jj".source = ../../config/starship-jj;
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles-nvim";
  };

  home.file.".config/karabiner" = {
    source = ../../config/karabiner;
    recursive = true;
    force = true;
  };
}
