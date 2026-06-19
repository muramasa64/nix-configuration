{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arto = {
      url = "github:arto-app/Arto";
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
          inputs.nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit inputs hostname username;
            };

            modules = [
              { nixpkgs.hostPlatform = system; }
              ./hosts/${hostname}/default.nix
              ./modules/darwin/home-manager.nix
              inputs.nix-index-database.darwinModules.nix-index
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
