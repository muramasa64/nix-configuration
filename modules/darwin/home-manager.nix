{ inputs, hostname, username, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  users.users.${username}.home = "/Users/${username}";

  home-manager = {
    extraSpecialArgs = { inherit inputs hostname username; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${username} = import ../../hosts/${hostname}/home.nix;
  };
}
