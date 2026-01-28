{ pkgs, inputs, username, ... }:
{
  nix-homebrew = {
    enable = true;
    user = username;
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
  };
}
