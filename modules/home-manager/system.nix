{ inputs, hostname, username, ... }:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs hostname username; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${username} = import ../../hosts/${hostname}/home.nix;
  };
}
