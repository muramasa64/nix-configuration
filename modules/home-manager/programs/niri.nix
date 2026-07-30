{ pkgs, ... }:
{
  # Tart (Apple Virtualization.framework) は Linux ゲストに 3D アクセラレーションを提供せず、
  # Mesa が llvmpipe になる。niri の TTY バックエンドは software EGL を明示的に拒否するため
  # (src/backend/tty.rs の `ensure!(!egl_device.is_software())`)、単独のセッションとしては起動しない。
  # そこで GNOME セッションの中で `niri` をウィンドウとして起動する (winit バックエンド)。
  # winit バックエンドにはこの判定が無いのでソフトウェアレンダリングでも動く。
  imports = [
    ./fuzzel.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    niri
    wl-clipboard
  ];

  # niri は設定ファイルを書き換えないので、Nix ストアへの symlink で問題ない
  xdg.configFile."niri/config.kdl".source = ../../../config/niri/config.kdl;

  # screenshot-path の保存先を用意しておく
  home.file."Pictures/Screenshots/.keep".text = "";
}
