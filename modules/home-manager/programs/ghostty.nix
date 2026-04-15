{ lib, config, pkgs, ... }:
{
  # ghosttyはdarwinでインストールできないのでonChangeフックを無効化する
  xdg.configFile."ghostty/config".onChange = lib.mkForce "";

  programs.ghostty = {
    enable = true;
    # ghosttyはdarwinでインストールできないので設定だけ管理する
    package = lib.mkIf pkgs.stdenv.isDarwin pkgs.emptyDirectory;
    enableFishIntegration = true;
    settings = {
      command = "${config.home.homeDirectory}/.nix-profile/bin/fish --login --interactive";
      shell-integration = "fish";
      shell-integration-features = "no-cursor";

      theme = "TokyoNight Storm";

      font-family = "UDEV Gothic 35NF";
      font-style = "Regular";
      font-size = 14;

      font-codepoint-map = [
        "U+3040-U+309F=UDEV Gothic 35NF"  # ひらがな
        "U+30A0-U+30FF=UDEV Gothic 35NF"  # カタカナ
        "U+3000-U+303F=UDEV Gothic 35NF"  # CJK記号・句読点
        "U+4E00-U+9FFF=UDEV Gothic 35NF"  # CJK統合漢字
        "U+F900-U+FAFF=UDEV Gothic 35NF"  # CJK互換漢字
        "U+FF00-U+FFEF=UDEV Gothic 35NF"  # 全角英数字・記号
      ];
      font-feature = "-dlig"; # 合字のバグ対策

      cursor-style = "block";

      window-width = 190;
      window-height = 60;

      window-inherit-working-directory = false; # 新規にwindowを開いた時の作業ディレクトリを継承しない
      working-directory = "home"; # デフォルトで開く作業ディレクトリ

      keybind = [
        "unconsumed:ctrl+shift+.=reload_config" # Ctrl+Shift+. で、設定をリロードする
        "super+c=copy_to_clipboard:plain" # Command+C で、プレーンテキストでクリップボードにコピーする
      ];
    };
  };
}
