{ pkgs, inputs, username, ... }:
{
  imports = [
    ./homebrew.nix
  ];

  environment.systemPackages = [ pkgs.vim ];

  nixpkgs.config.allowUnfree = true;

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

  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Spotlightの検索ウィンドウを space + ctrl で開くショートカット
        "64" = {
          enabled = true;
          value = {
            type = "standard";
            parameters = [
              65535
              49     # Space (key code)
              262144 # Modifier key (ctrl)
            ];
          };
        };
        # 入力ソースの切り替えを無効化
        "60" = {
          enabled = false;
        };
        "61" = {
          enabled = false;
        };
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

}
