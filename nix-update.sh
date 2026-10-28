#!/usr/bin/env bash
# nix flake update → switch → パッケージ変更差分表示
# Usage: ./nix-update.sh [flake-target]
set -euo pipefail

cd "$(dirname "$0")"

# フレークのターゲットを決定（引数 > ユーザー名で自動検出）
if [[ -n "${1:-}" ]]; then
  flake_target="$1"
elif [[ "$USER" == "isobe" ]]; then
  flake_target="work"
else
  flake_target="home"
fi

# 現在のシステムクロージャを保存
old_system="$(readlink /run/current-system)"

# flake.lock を更新
echo "==> Updating flake inputs..."
nix flake update

# 新しい設定に切り替え（nix-output-monitor で進捗表示）
echo "==> Switching to .#$flake_target..."
sudo nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake ".#$flake_target" --log-format internal-json -v 2>&1 | nom --json

# バージョン変更を表示
new_system="$(readlink /run/current-system)"
echo ""
if [[ "$old_system" != "$new_system" ]]; then
  echo "==> Package changes:"
  nix store diff-closures "$old_system" "$new_system"
else
  echo "==> No package changes."
fi
