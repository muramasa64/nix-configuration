{ inputs, config, lib, pkgs, ... }:
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
    ./programs/starship.nix
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];

  home.sessionVariables = {
    LANG = "ja_JP.UTF-8";
    XDG_CONFIG_HOME = "$HOME/.config";
    devbox_no_prompt = "true";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  home.packages = with pkgs; [
    inputs.starship-jj.packages.${pkgs.stdenv.hostPlatform.system}.default
    bash
    bat
    comma
    curl
    delta
    devenv
    diffedit3
    diffnav
    dust
    eza
    fd
    fzf
    git
    git-filter-repo
    jd-diff-patch
    lua-language-server
    neovim
    neovim-remote
    nix-output-monitor
    nixd
    nixfmt
    # nushell
    nvd
    ripgrep
    sd
    tree-sitter
    typescript-language-server
    vscode-langservers-extracted
  ];

  xdg.configFile = {
    "starship-jj".source = ../../config/starship-jj;
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles-nvim";
  };

  home.activation.setConfigDirPermissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    chmod 700 "$HOME/.config"
  '';
}
