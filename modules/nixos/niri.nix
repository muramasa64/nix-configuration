{ pkgs, ... }:
{
  # niri 本体。xdg.portal / gnome-keyring / polkit / dconf / hardware.graphics /
  # swaylock の PAM 設定は nixpkgs の programs.niri モジュールが面倒を見る。
  programs.niri.enable = true;

  # ログインマネージャは greetd + tuigreet
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
    };
  };

  # niri は X11 クライアントの接続時に xwayland-satellite を自動起動するので
  # $PATH に置いておく
  environment.systemPackages = with pkgs; [
    polkit_gnome
    xwayland-satellite
  ];

  # polkit の認証エージェント (systemd user service が同梱されていないため自前で定義する)
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Electron 系アプリを Wayland ネイティブで動かす
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
