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
  };

  outputs = inputs@{
    self,
     nix-darwin,
     nixpkgs,
     home-manager,
     nix-homebrew
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

      nixpkgs.hostPlatform = "aarch64-darwin";

      homebrew = {
        enable = true;
        onActivation.autoUpdate = true;
        caskArgs.no_quarantine = true;
        casks = [
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
      ];
    };
  };
}
