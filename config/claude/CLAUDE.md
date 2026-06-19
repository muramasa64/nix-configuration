# Responses

- Respond in Japanese.
- The language for code comments and commit messages should follow the existing conventions of each repository.
- When writing documentation in Japanese, use the `/japanese-tech-writing` skill.

# Environment

- macOS (Apple Silicon, aarch64-darwin). The shell is fish.
- dotfiles are managed with nix flake (nix-darwin + home-manager). The location is ~/.config/nix-configuration.
- Use jj (jujutsu) for version control.
- The editor is neovim. The terminal is ghostty.
- Frequently used CLI tools: ripgrep (rg), bat, eza, fzf, direnv. Prioritize rg over grep/find.
- If using a tool that is not installed, it is acceptable to run it using ',' (comma).

# Working Style

- Keep explanations concise. Avoid redundant preambles or obvious summaries, and state the conclusion first.
- Do not proceed without certainty; confirm any ambiguities or destructive operations in advance.
- Do not write obvious comments. Follow the existing code style, naming, and conventions.
- Always create a design document first before implementing code.

# Development Rules

- Adopt Specification-Driven Development.
- Do not implement features before updating the documentation.
- Always update the following items before writing implementation code:
    - docs/use-cases.md
    - docs/requirements.md
    - docs/spec.md

# README Rules

- Write `README.md` in English.
- Provide the Japanese version as `README_ja.md`.
- Add a language switcher line at the top of each (e.g. `English | [日本語](README_ja.md)` and `[English](README.md) | 日本語`).
- Keep both versions in sync in content.

# TDD Rules (t-wada style)

- Follow the workflow recommended by t-wada.
- 1 Test -> Confirm Failure -> Minimal Implementation -> All Tests Green -> Refactoring
- Do not touch the implementation code before writing a test.
- Ensure the test fails (RED) before proceeding to the next step.

# Implementation Order

1. Define interfaces.
2. Create test cases (where applicable).
3. Implement minimal functionality.
4. Expand functionality incrementally.

Do not perform large-scale implementation all at once.

# Version Control

- In principle, use jj and do not use git. Git may be used only if the task cannot be achieved with jj.
- Run `jj commit` before changing code and executing anything.
- Perform push only when requested by the user.
- Commit messages should basically follow the Conventional Commits format (feat:, fix:, chore:, etc.).
  However, if a repository has its own existing conventions, follow them.
