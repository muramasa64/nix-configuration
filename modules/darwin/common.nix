{ pkgs, inputs, username, ... }:
{
  imports = [
    ./homebrew.nix
  ];

  environment.systemPackages = [ pkgs.vim ];

  nix.enable = true;
  nix.package = pkgs.nix;
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
    ApplePressAndHoldEnabled = false;
    AppleShowAllExtensions = true;
  };

  system.defaults.finder = {
    AppleShowAllFiles = false;
    AppleShowAllExtensions = true;
  };

  system.defaults.trackpad = {
    TrackpadThreeFingerDrag = true;
  };

  system.defaults.dock = {
    autohide = true;
    orientation = "bottom";
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
    NSGlobalDomain = {
      NSAutoFillHeuristicControllerEnabled = 0;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

}
