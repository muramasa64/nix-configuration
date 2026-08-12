{ config, pkgs, ... }:
{
  programs.herdr = {
    enable = true;
    settings = {
      terminal = {
        default_shell = "fish";
      };
      theme = {
        name = "catppuccin";
        auto_switch = true;
        light_name = "catppuccin-latte";
        dark_name = "catppuccin";
      };
      keys = {
        prefix = "ctrl+a";
      };
      ui = {
        sidebar_width = 32;
        agent_panel_sort = "priority";
        toast.delivery = "herdr";
        sound.enabled = true;
        copy_on_select = false;
      };
    };
  };
}
