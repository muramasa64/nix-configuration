{ config, ... }:
{
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-configuration/config/claude/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix-configuration/config/claude/CLAUDE.md";

  home.file.".claude/skills" = {
    source = ../../../config/claude/skills;
    recursive = true;
  };
}
