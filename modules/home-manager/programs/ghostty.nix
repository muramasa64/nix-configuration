{ lib, config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    # ghosttyはdarwinでインストールできないので設定だけ管理する
    package = lib.mkIf pkgs.stdenv.isDarwin pkgs.emptyDirectory;
    enableFishIntegration = true;
    settings = {
      command = "${pkgs.fish}/bin/fish --login --interactive";
      shell-integration = "fish";
      shell-integration-features = "no-cursor";

      theme = "TokyoNight Storm";

      font-family = "UDEV Gothic 35NF";
      font-style = "Reguler";
      font-size = 14;

      cursor-style = "block";

      window-width = 190;
      window-height = 60;

      keybind = [
        "unconsumed:ctrl+shift+.=reload_config"
      ];
    };
  };
}
