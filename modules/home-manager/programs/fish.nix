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
    '';

    # shellInit: 全てのfishセッションで実行される初期化処理
    shellInit = ''
      # Nix daemon
      # if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      #   source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      # end

      # for p in /etc/profiles/per-user/$USER/bin /run/current-system/sw/bin
      #   if not contains $p $fish_user_paths
      #     set -gx fish_user_paths $p $fish_user_paths
      #   end
      # end

      fish_add_path /opt/homebrew/bin
      fish_add_path /opt/homebrew/sbin
      fish_add_path ~/bin
      # fish_add_path ~/.nix-profile/bin
      # fish_add_path /run/current-system/sw/bin

      set -gx LANG ja_JP.UTF-8
      set -gx XDG_CONFIG_HOME $HOME/.config
      set -gx PIP_CERT "/Library/Application Support/Netskope/STAgent/data/nscacert.pem"
      set -gx devbox_no_prompt true

      set -x EDITOR nvim
      set -x MANPAGER "nvim +Man!"

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

          # 新しい設定に切り替え
          echo "==> Switching to .#$flake_target..."
          sudo nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake ".#$flake_target"
          or return 1

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
      {
        name = "nix-env.fish";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
    ];
  };
}

