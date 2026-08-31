{ pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/darwin/common.nix
  ];

  security.pki.certificateFiles = [
    ../../config/certs/nscacert.pem
  ];

  nix.settings = {
    max-jobs = 18;
    ssl-cert-file = /etc/ssl/certs/ca-certificates.crt;
  };

  system.defaults.dock = {
    persistent-apps = [
      { app = "/System/Applications/Mail.app"; }
      { app = "/System/Applications/Calendar.app"; }
      { app = "/System/Applications/Reminders.app"; }
      { app = "/System/Applications/Home.app"; }
      { app = "/Applications/Reeder.app"; }
      { app = "/Applications/Firefox.app"; }
      { app = "/Applications/Firefox Developer Edition.app"; }
      { app = "/Applications/Firefox Nightly.app"; }
      { app = "/Applications/Nani.app"; }
      { app = "/Applications/Obsidian.app"; }
      { app = "/Applications/OmniFocus.app"; }
      { app = "/Applications/Ghostty.app"; }
      { app = "/Applications/zoom.us.app"; }
      { app = "/System/Applications/Messages.app"; }
      { app = "/System/Applications/Books.app"; }
    ];
  };

  homebrew = {
    taps = [
      "nikitabobko/tap"
      {
        name = "pingidentity/tap";
        trusted = true;
      }
    ];
    casks = [
      "bruno"
      "devtoys"
      "microsoft-edge"
      "orbstack"
      "windows-app"
      "xca"
    ];
    brews = [
      "resterm"
      "pingone-mcp-server"
    ];
  };
}
