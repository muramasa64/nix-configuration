{
  description = "Example nix-darwin system flake";

  inputs = {
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
     nix-darwin,
     nixpkgs,
     home-manager,
     nix-homebrew,
     starship-jj,
     ...
  }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages =
        [ pkgs.vim
        ];

      nix.settings = {
        experimental-features = "nix-command flakes";
        max-jobs = 8;
        trusted-users = [ "root" "kazuhiko" ];
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 6;
      system.primaryUser = "kazuhiko";

      system.defaults.NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 25;
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
              path = "/Users/kazuhiko/Downloads";
              arrangement = "date-added";
              displayas = "stack";
              showas = "fan";
            };
          }
        ];
      };


      nixpkgs.hostPlatform = "aarch64-darwin";

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
    };
  in
  {
    # darwin-rebuild build --flake .#test-macbook-air
    darwinConfigurations."test-macbook-air" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            user = "kazuhiko";
          };
        }
        home-manager.darwinModules.home-manager {
          users.users.kazuhiko.home = "/Users/kazuhiko";
          home-manager = {
            extraSpecialArgs.starship-jj-pkg = starship-jj.packages."aarch64-darwin".default;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.kazuhiko = import ./home.nix;
          };
        }
      ];
    };
  };
}
