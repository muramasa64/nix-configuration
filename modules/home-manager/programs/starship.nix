{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = "[░▒▓](#a3aed2)[  ](bg:#a3aed2 fg:#090c0c)[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#394260)\${custom.git_branch}\${custom.git_status}\${custom.starship-jj}[](fg:#394260 bg:#212736)$nodejs$rust$golang$php$ruby$python[](fg:#212736 bg:#1d2230)$time[](fg:#1d2230)\n\${env_var.VIRTUAL_ENV_PROMPT}\${env_var.DEVBOX_SHELL_ENABLED}\${env_var.SHELL}$character";

      env_var = {
        VIRTUAL_ENV_PROMPT = {
          variable = "VIRTUAL_ENV_PROMPT";
          format = "[($env_value)](fg:#a3aed2 bg:#1d2230) ";
        };

        DEVBOX_SHELL_ENABLED = {
          variable = "DEVBOX_SHELL_ENABLED";
          format = "[(devbox)](fg:#a3aed2 bg:#1d2230) ";
        };

        SHELL = {
          variable = "STARSHIP_SHELL";
          format = "[$env_value](fg:#a3aed2 bg:#1d2230) ";
          default = "";
        };
      };

      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        fish_style_pwd_dir_length = 1;
        truncation_length = 3;
      };

      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      deno = {
        symbol = "🦕";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      ruby = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };

      custom = {
        starship-jj = {
          command = "prompt";
          ignore_timeout = true;
          shell = ["starship-jj" "--ignore-working-copy" "starship"];
          use_stdin = false;
          when = true;
        };

        git_branch = {
          when = "! jj --ignore-working-copy root";
          command = ''
            starship module git_branch | sd '.*\s+(\S+)\s*.*' '$1'
          '';
          description = "Only show git_branch if we're not in a jj repo";
          symbol = "";
          style = "bg:#394260";
          format = "[[ $symbol $output](fg:#769ff0 bg:#394260)]($style)";
        };

        git_status = {
          when = "! jj --ignore-working-copy root";
          command = ''
            starship module git_status | sed 's/\x1b\[[0-9;]*m//g'
          '';
          description = "Only show git_branch if we're not in a jj repo";
          style = "bg:#394260";
          format = "[($output)(fg:#769ff0 bg:#394260)]($style)";
        };
      };
    };
  };
}

