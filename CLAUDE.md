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

**Update flake inputs:**
```bash
nix flake update
```

## Architecture

This is a macOS (aarch64-darwin) Nix flake configuration managing two machines via nix-darwin + home-manager.

### Two-Layer System

1. **Darwin layer** (`modules/darwin/`) — system-level (macOS defaults, Homebrew, sudo Touch ID)
   - `common.nix`: Shared macOS system defaults (Finder, Dock, Trackpad, Keyboard, Accessibility, Nix settings)
   - `homebrew.nix`: Homebrew casks and Mac App Store apps

2. **Home-manager layer** (`modules/home-manager/`) — user-level packages and dotfiles
   - `common.nix`: Core tools installed on both machines (neovim, fish, git, jj, ripgrep, bat, eza, etc.) and symlinks for external configs
   - `programs/`: Per-program configuration modules (fish, git, ghostty, jj, starship, direnv, fzf, arto)

### Host-Specific Configs (`hosts/`)

- `hosts/work/` — MacBook Pro M1, user `isobe`; adds work-specific tools: awscli2, claude-code, duckdb, gh, utm
- `hosts/test/` — MacBook Air M1, user `kazuhiko`; lighter setup

Each host has `default.nix` (Darwin system config) and `home.nix` (home-manager user config) that import the common modules and add machine-specific overrides.

### External Configs

Neovim config is managed externally at `~/repos/dotfiles-nvim` — home-manager symlinks `~/.config/nvim` to it. Karabiner and Starship configs are managed via `config/` directory.

### Key Inputs (flake.nix)

- `nixpkgs` (unstable)
- `nix-darwin` — macOS system management
- `home-manager` — user environment
- `nix-homebrew` — Homebrew integration
- `starship-jj` — custom Starship build with jj support
- `arto` — custom app
