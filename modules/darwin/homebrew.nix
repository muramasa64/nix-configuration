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
    caskArgs.no_quarantine = true;
    casks = [
      "bitwarden"
      "firefox"
      "ghostty"
      "karabiner-elements"
      "obsidian"
      "nani"
      "menumeters"
    ];
    masApps = {
      "Reeder Classic." = 1529448980;
      "OmniFocus 4" = 1542143627;
      "Snip : Snippets Manager" = 1527428847;
      "辞書 by 物書堂" = 1380563956;
    };
  };
}
