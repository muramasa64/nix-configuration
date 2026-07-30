{ ... }:
{
  programs.waybar = {
    enable = true;
    # GNOME セッションの graphical-session.target に釣られて起動しないよう systemd 連携は使わず、
    # ネストした niri の spawn-at-startup から起動する
    systemd.enable = false;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 8;

      modules-left = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "pulseaudio" "cpu" "memory" ];

      "niri/workspaces".format = "{index}";

      "niri/window" = {
        format = "{title}";
        max-length = 80;
        separate-outputs = true;
      };

      clock = {
        format = "{:%Y-%m-%d (%a) %H:%M}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar.mode = "month";
      };

      pulseaudio = {
        format = "󰕾 {volume}%";
        format-muted = "󰝟 muted";
        on-click = "pavucontrol";
      };

      cpu.format = "󰻠 {usage}%";

      memory.format = "󰍛 {percentage}%";

      tray.spacing = 8;
    };

    style = ''
      * {
        font-family: "UDEV Gothic 35NF";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: #1a1b26;
        color: #c0caf5;
      }

      #workspaces button {
        padding: 0 8px;
        color: #565f89;
        background-color: transparent;
      }

      #workspaces button.active {
        color: #1a1b26;
        background-color: #7aa2f7;
      }

      #workspaces button.urgent {
        color: #1a1b26;
        background-color: #f7768e;
      }

      #window {
        color: #a9b1d6;
      }

      #clock,
      #cpu,
      #memory,
      #pulseaudio,
      #tray {
        padding: 0 10px;
      }

      #clock {
        color: #7aa2f7;
      }

      #memory {
        color: #9ece6a;
      }

      #pulseaudio.muted {
        color: #565f89;
      }
    '';
  };
}
