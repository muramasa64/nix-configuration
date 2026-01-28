{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
     flake-parts,
     ...
  }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [
        "aarch64-darwin"
      ];

      flake = let
        mkDarwinSystem = { hostname, username, system ? "aarch64-darwin" }:
          let
            starship-jj-pkg = inputs.starship-jj.packages.${system}.default;
          in
            inputs.nix-darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit inputs hostname username starship-jj-pkg;
              };

              modules = [
                ./modules/darwin/common.nix
                ./hosts/${hostname}/default.nix
                inputs.nix-homebrew.darwinModules.nix-homebrew
                inputs.home-manager.darwinModules.home-manager
                {
                  users.users.${username}.home = "/Users/${username}";
                  home-manager = {
                    extraSpecialArgs = {
                      inherit inputs hostname username starship-jj-pkg;
                    };
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "backup";
                    users.${username} = import ./hosts/${hostname}/home.nix;
                  };
                }
              ];
            };
      in {
        # sudo darwin-rebuild build --flake .#test
        darwinConfigurations = {
          "test" = mkDarwinSystem {
            hostname = "test";
            username = "kazuhiko";
          };

          "work" = mkDarwinSystem {
            hostname = "work";
            username = "isobe";
          };
        };
      };
    };
}
