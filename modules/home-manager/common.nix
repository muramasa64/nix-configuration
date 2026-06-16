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

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "$HOME/.local/bin"
    "$HOME/bin"
  ];

  home.sessionVariables = {
    LANG = "ja_JP.UTF-8";
    XDG_CONFIG_HOME = "$HOME/.config";
    PIP_CERT = "/Library/Application Support/Netskope/STAgent/data/nscacert.pem";
    devbox_no_prompt = "true";
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  home.packages = with pkgs; [
    inputs.starship-jj.packages.${system}.default
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
    jd-diff-patch
    lua-language-server
    mas
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

  home.file.".config/karabiner" = {
    source = ../../config/karabiner;
    recursive = true;
    force = true;
  };
}
