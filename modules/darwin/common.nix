{ pkgs, inputs, username, ... }:
{
  imports = [
    ./homebrew.nix
  ];

  environment.systemPackages = [ pkgs.vim ];

  nixpkgs.config.allowUnfree = true;

  # Workaround for aarch64-darwin build failure (nixpkgs#507531):
  # direnv's fish integration test is killed with signal 9 on Apple Silicon,
  # caused by libarchive 3.8.6 breaking fish. Skip the fish test to allow
  # direnv to build successfully.
  nixpkgs.overlays = [
    (_final: prev: {
      direnv = prev.direnv.overrideAttrs (_old: {
        doCheck = false;
      });
    })
  ];

  nix.enable = true;
  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = "nix-command flakes";
    max-jobs = 18;
    trusted-users = [ "root" username ];
  };

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  system.stateVersion = 6;
  system.primaryUser = username;

  system.defaults.NSGlobalDomain = {
    KeyRepeat = 2;
    InitialKeyRepeat = 25;
    AppleScrollerPagingBehavior = true; # スクロールバーをクリックした位置に移動する
    AppleShowScrollBars = "Always"; # スクロールバーを常に表示する
    ApplePressAndHoldEnabled = false; # キー長押しでアクセント入力する機能を無効にする
    AppleShowAllFiles = true; # Finderで隠しファイルを表示する
    AppleShowAllExtensions = true; # Finderですべての拡張子を表示する
  };

  system.defaults.finder = {
    AppleShowAllFiles = true; # Finderで隠しファイルを表示する
    AppleShowAllExtensions = true; # Finderですべての拡張子を表示する
  };

  system.defaults.trackpad = {
    TrackpadThreeFingerDrag = true; # Trackpadの3本指でドラッグを有効にする
  };

  system.defaults.dock = {
    autohide = true; # Dockを自動非表示をオン
    orientation = "bottom";
    persistent-others = [
      {
        folder = { # ダウンロードフォルダの設定
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

  security.pam.services.sudo_local.touchIdAuth = true; # sudoをパスワードではなくTouch IDで承認する

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      hackgen-nf-font
      source-han-sans
      udev-gothic
      udev-gothic-nf
    ];
  };
}
