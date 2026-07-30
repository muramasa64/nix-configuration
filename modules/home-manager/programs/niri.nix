{ pkgs, ... }:
{
  imports = [
    ./fuzzel.nix
    ./mako.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    grim
    nautilus       # xdg-desktop-portal-gnome のファイル選択ダイアログが要求する
    pavucontrol
    playerctl
    slurp
    swappy
    wl-clipboard
  ];

  programs.swaylock = {
    enable = true;
    settings = {
      color = "1a1b26";       # TokyoNight Storm background
      indicator-radius = 100;
      indicator-thickness = 10;
      ring-color = "3b4261";
      key-hl-color = "7aa2f7";
      line-color = "1a1b26";
      inside-color = "1a1b26";
      text-color = "c0caf5";
      show-failed-attempts = true;
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 900;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };

  # niri は設定ファイルを書き換えないので、Nix ストアへの symlink で問題ない
  xdg.configFile."niri/config.kdl".source = ../../../config/niri/config.kdl;

  # screenshot-path の保存先を用意しておく
  home.file."Pictures/Screenshots/.keep".text = "";
}
