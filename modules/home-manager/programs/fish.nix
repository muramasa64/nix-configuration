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

      direnv hook fish | source

      # OrbStack統合
      source ~/.orbstack/shell/init2.fish 2>/dev/null || :
    '';

    shellAbbrs = {
      rm = "trash";
      diff = "delta";
    };

    functions = {
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

      # cat →bat
      cat = {
        wraps = "bat";
        body = ''
          if type -q bat
            bat --paging=never $argv
          else
            command cat $argv
          end
        '';
      };

      # grep →ripgrep
      grep = {
        wraps = "rg";
        body = ''
          if type -q rg
            rg $argv
          else
            command grep $argv
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

