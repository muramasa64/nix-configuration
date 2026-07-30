# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Apply Commands

**Apply configuration for work machine (MacBook Pro M1):**
```bash
sudo nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake .#work --verbose
```

**Apply configuration for test machine (MacBook Air M1):**
```bash
sudo nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake .#test --verbose
```

**Apply configuration for NixOS guest (Tart VM), run on the guest itself:**
```bash
sudo nixos-rebuild switch --flake .#nixos-tart
```

**Update flake inputs:**
```bash
nix flake update
```

## Architecture

This is a Nix flake configuration managing several macOS (aarch64-darwin) machines via nix-darwin + home-manager, plus one NixOS (aarch64-linux) guest via nixosSystem + home-manager.

### Two-Layer System

1. **System layer**
   - `modules/darwin/` — macOS system-level (macOS defaults, Homebrew, sudo Touch ID)
     - `common.nix`: Shared macOS system defaults (Finder, Dock, Trackpad, Keyboard, Accessibility, Nix settings)
     - `homebrew.nix`: Homebrew casks and Mac App Store apps
     - `home-manager.nix`: Wires home-manager into the Darwin system
   - `modules/nixos/` — NixOS system-level
     - `home-manager.nix`: Wires home-manager into the NixOS system

2. **Home-manager layer** (`modules/home-manager/`) — user-level packages and dotfiles
   - `base.nix`: Cross-platform core (neovim, fish, git, jj, ripgrep, bat, eza, etc.) and symlinks for external configs
   - `darwin.nix`: `base.nix` plus macOS-only bits (Homebrew paths, mas, Karabiner config)
   - `programs/`: Per-program configuration modules (fish, git, ghostty, jj, starship, direnv, fzf, claude)
     - `niri.nix` installs niri plus `waybar.nix` / `fuzzel.nix` and symlinks `config/niri/config.kdl`. On `nixos-tart` niri runs **nested inside the GNOME session** (winit backend), because Tart gives no 3D acceleration and niri's TTY backend refuses software EGL

### Host-Specific Configs (`hosts/`)

- `hosts/work/` — MacBook Pro M1, user `isobe`; adds work-specific tools: awscli2, claude-code, duckdb, gh, utm
- `hosts/test/` — MacBook Air M1, user `kazuhiko`; lighter setup
- `hosts/home/` — MacBook Pro M1, user `kazuhiko`
- `hosts/nixos-tart/` — NixOS guest on Tart, user `kazuhiko`; GNOME, fcitx5-mozc, xremap, plus niri run nested inside GNOME. Has `hardware-configuration.nix` and imports `modules/home-manager/base.nix` + `modules/home-manager/programs/niri.nix` (not `darwin.nix`, which is macOS-only)

Each host has `default.nix` (system config) and `home.nix` (home-manager user config) that import the common modules and add machine-specific overrides. `hostname` / `username` are passed down via `specialArgs`.

### External Configs

Neovim config is managed externally at `~/repos/dotfiles-nvim` — home-manager symlinks `~/.config/nvim` to it. Karabiner, Starship and niri configs are managed via `config/` directory.

### Key Inputs (flake.nix)

- `nixpkgs` (unstable)
- `nix-darwin` — macOS system management
- `home-manager` — user environment
- `nix-homebrew` — Homebrew integration
- `starship-jj` — custom Starship build with jj support
- `xremap` — key remapper used by the NixOS host
- `arto` — custom app
