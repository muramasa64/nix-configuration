{ ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "UDEV Gothic 35NF:size=13";
        terminal = "ghostty";
        layer = "overlay";
        width = 45;
        lines = 12;
        horizontal-pad = 24;
        vertical-pad = 16;
        inner-pad = 8;
      };

      # TokyoNight Storm
      colors = {
        background = "1a1b26f0";
        text = "c0caf5ff";
        match = "7aa2f7ff";
        selection = "3b4261ff";
        selection-text = "c0caf5ff";
        selection-match = "7aa2f7ff";
        border = "7aa2f7ff";
      };

      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
