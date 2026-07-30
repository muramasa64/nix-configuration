{ ... }:
{
  services.mako = {
    enable = true;
    settings = {
      font = "UDEV Gothic 35NF 12";
      width = 400;
      height = 150;
      margin = "12";
      padding = "12";
      border-size = 2;
      border-radius = 8;
      default-timeout = 8000;

      # TokyoNight Storm
      background-color = "#1a1b26f0";
      text-color = "#c0caf5";
      border-color = "#7aa2f7";

      "urgency=critical" = {
        border-color = "#f7768e";
        default-timeout = 0;
      };
    };
  };
}
