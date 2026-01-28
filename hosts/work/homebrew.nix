{ pkgs, inputs, username, ... }:
{
  homebrew = {
    taps = [
      "nikitabobko/tap"
      "pingidentity/tap"
    ];
    casks = [
      "bruno"
      "devtoys"
      "firefox@developer-edition"
      "firefox@nightly"
      "microsoft-edge"
      "orbstack"
      "visual-studio-code"
      "windows-app"
      "xca"
    ];
    brews = [
      "pingcli"
      "resterm"
    ];
  };
}
