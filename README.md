# nix-configuration

## Targets

| Machine | Name | OS | System |
|---------|------|----|--------|
| MacBook Air M1 | test | macOS 26.2 | aarch64-darwin |

## Usage

### test

```sh
sudo nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake .#test
```

