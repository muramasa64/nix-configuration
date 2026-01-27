{ pkgs, inputs, username, ... }:
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
  ];

  environment.systemPackages = [ pkgs.vim ];

  nix.settings = {
    experimental-features = "nix-command flakes";
    max-jobs = 8;
    trusted-users = [ "root" username ];
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.stateVersion = 6;
  system.primaryUser = username;

  system.defaults.NSGlobalDomain = {
    KeyRepeat = 2;
    InitialKeyRepeat = 25;
    AppleScrollerPagingBehavior = true;
    AppleShowScrollBars = "Always";
  };

  system.defaults.trackpad = {
    TrackpadThreeFingerDrag = true;
  };

  system.defaults.dock = {
    autohide = true;
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
    persistent-others = [
      {
        folder = {
          path = "/Users/${username}/Downloads";
          arrangement = "date-added";
          displayas = "stack";
          showas = "fan";
        };
      }
    ];
  };

  system.defaults.menuExtraClock.Show24Hour = true;

  system.defaults.universalaccess = {
    closeViewScrollWheelToggle = true;
    mouseDriverCursorSize = 1.5;
    reduceMotion = true;
  };

  system.defaults.CustomSystemPreferences = {
    "com.apple.Accessibility".ReduceMotionEnabled = 1;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix-homebrew = {
    enable = true;
    user = username;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    caskArgs.no_quarantine = true;
    casks = [
      "firefox"
      "ghostty"
      "karabiner-elements"
    ];
  };

  users.users.${username}.home = "/Users/${username}";
  home-manager = {
    extraSpecialArgs.starship-jj-pkg = inputs.starship-jj.packages."aarch64-darwin".default;
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./home.nix;
  };
}
