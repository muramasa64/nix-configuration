{ pkgs, inputs, username, ... }:
{
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    casks = [
      "aquaskk"
      "bitwarden"
      "firefox"
      "ghostty"
      "karabiner-elements"
      "obsidian"
      "nani"
      "menumeters"
    ];
    # masAppsでインストールできなくなったっぽい
    # 1. mas 6.x で signin コマンドが削除された
    # mas 6.0.1 は CLI でのサインインを提供しておらず、App Store.app で GUI ログインしている状態を前提としている
    # brew bundle が root として実行される
    # sudo nix run nix-darwin -- switch で動かすため、brew bundle が root コンテキストで実行される
    # root は App Store のユーザーセッションにアクセスできないため、mas install が失敗する
    # masApps = {
    #   "Reeder Classic." = 1529448980;
    #   "OmniFocus 4" = 1542143627;
    #   "Snip : Snippets Manager" = 1527428847;
    #   "辞書 by 物書堂" = 1380563956;
    # };
  };
}
