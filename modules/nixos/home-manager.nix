{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../home-manager/system.nix
  ];
}
