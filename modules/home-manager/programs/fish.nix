{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    generateCompletions = true;

    # Welcome メッセージを非表示
    interactiveShellInit = ''
      set fish_greeting ""

      # jj補完
      if type -q jj
        jj util completion fish | source
      end

      # AWS CLI補完
      if type -q aws
        complete -c aws -f -a '(
          begin
            set -lx COMP_SHELL fish
            set -lx COMP_LINE (commandline)
            aws_completer
          end
        )'
      end

      # OrbStack統合
      source ~/.orbstack/shell/init2.fish 2>/dev/null || :
    '';

    shellAbbrs = {
      rm = "trash";
      diff = "delta";
    };

    functions = {
      # nix flake update → switch → パッケージ変更差分表示
      nix-update = {
        description = "Update flake inputs, switch nix-darwin config, and show package version changes";
        body = ''
          # フレークのターゲットを決定（引数 > ユーザー名で自動検出）
          if test -n "$argv[1]"
              set flake_target $argv[1]
          else if test "$USER" = "isobe"
              set flake_target "work"
          else
              set flake_target "test"
          end

          # 現在のシステムクロージャを保存
          set old_system (readlink /run/current-system)

          # flake.lock を更新
          echo "==> Updating flake inputs..."
          nix flake update
          or return 1

          # 新しい設定に切り替え（nix-output-monitor で進捗表示）
          echo "==> Switching to .#$flake_target..."
          sudo nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake ".#$flake_target" --log-format internal-json -v 2>&1 | nom --json
          if test $pipestatus[1] -ne 0
              return 1
          end

          # バージョン変更を表示
          set new_system (readlink /run/current-system)
          if test "$old_system" != "$new_system"
              echo ""
              echo "==> Package changes:"
              nix store diff-closures $old_system $new_system
          else
              echo ""
              echo "==> No package changes."
          end
        '';
      };

      # ls →eza
      # https://syu-m-5151.hatenablog.com/entry/2025/12/14/132552
      ls = {
        wraps = "eza";
        body = ''
          if type -q eza
            eza --icons --group-directories-first $argv
          else
            command ls $argv
          end
        '';
      };
    };

    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "7f0cf099ae1e1e4ab38f46350ed6757d54471de7";
          sha256 = "sha256-4+k5rSoxkTtYFh/lEjhRkVYa2S4KEzJ/IJbyJl+rJjQ=";
        };
      }
    ];
  };
}

