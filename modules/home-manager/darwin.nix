{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    ./base.nix
  ];

  home.sessionPath = lib.mkBefore [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  home.packages = with pkgs; [
    mas
  ];

  home.file.".config/karabiner" = {
    source = ../../config/karabiner;
    recursive = true;
    force = true;
  };
}
