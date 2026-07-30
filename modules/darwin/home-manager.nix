{ inputs, username, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../home-manager/system.nix
  ];

  users.users.${username}.home = "/Users/${username}";
}
