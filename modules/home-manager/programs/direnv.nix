{ config, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    config = {
      global = {
        log_format = "-";
        log_filter = "^$";
      };
    };
  };
}
