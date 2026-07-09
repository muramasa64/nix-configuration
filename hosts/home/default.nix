{ pkgs, hostname, username, ... }:
{
  imports = [
    ../../modules/darwin/common.nix
  ];

  system.defaults.dock = {
    persistent-apps = [
      { app = "/System/Applications/Mail.app"; }
      { app = "/System/Applications/Calendar.app"; }
      { app = "/System/Applications/Reminders.app"; }
      { app = "/System/Applications/Home.app"; }
      { app = "/Applications/Firefox.app"; }
      { app = "/Applications/Ghostty.app"; }
      { app = "/System/Applications/Messages.app"; }
      { app = "/System/Applications/Books.app"; }
    ];
  };
}
