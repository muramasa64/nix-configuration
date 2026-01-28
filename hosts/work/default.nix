{ pkgs, hostname, username, ... }:
{
  security.pki.certificateFiles = [
    ../../config/certs/nscacert.pem
  ];

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
      { app = "/Applications/Evernote.app"; }
      { app = "/Applications/Nani.app"; }
      { app = "/Applications/Obsidian.app"; }
      { app = "/Applications/Ghostty.app"; }
      { app = "/Applications/Zoom.app"; }
      { app = "/System/Applications/Messages.app"; }
      { app = "/System/Applications/Books.app"; }
    ];
  };
}
