{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    generateCompletions = true;

    # Welcome メッセージを非表示
    interactiveShellInit = ''
      set fish_greeting ""

      # secrets
      if test -f ~/.config/fish/secrets.fish
        source ~/.config/fish/secrets.fish
      end

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

      # herdrはEDITORをnvimに固定して起動する
      # nvim init.luaがEDITOR=nvr(既存nvimウィンドウ再利用)に上書きするが、
      # herdrサーバーは長時間稼働し続けるため、起動時のnvimが終了すると
      # nvrの接続先ソケットが無効になり、Claude Code等からのエディタ起動が失敗する
      herdr = {
        wraps = "herdr";
        body = ''
          env EDITOR=nvim VISUAL=nvim command herdr $argv
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

