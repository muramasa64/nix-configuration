{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format = "[](red)$os$username[](bg:peach fg:red)$directory[](bg:yellow fg:peach)\${custom.git_branch}\${custom.git_status}\${custom.starship-jj}[](fg:yellow bg:green)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:green bg:sapphire)$conda[](fg:sapphire bg:lavender)$time[ ](fg:lavender)$cmd_duration$line_break$character";

      palette = "catppuccin_mocha";

      character = {
        disabled = false;
        error_symbol = "[❯](bold fg:red)";
        success_symbol = "[❯](bold fg:green)";
        vimcmd_replace_one_symbol = "[❮](bold fg:lavender)";
        vimcmd_replace_symbol = "[❮](bold fg:lavender)";
        vimcmd_symbol = "[❮](bold fg:green)";
        vimcmd_visual_symbol = "[❮](bold fg:yellow)";
      };

      os = {
        disabled = false;
        style = "bg:red fg:crust";
        symbols = {
          AOSC = "";
          Alpine = "";
          Amazon = "";
          Android = "";
          Arch = "󰣇";
          Artix = "󰣇";
          CentOS = "";
          Debian = "󰣚";
          Fedora = "󰣛";
          Gentoo = "󰣨";
          Linux = "󰌽";
          Macos = "󰀵";
          Manjaro = "";
          Mint = "󰣭";
          Raspbian = "󰐿";
          RedHatEnterprise = "󱄛";
          Redhat = "󱄛";
          SUSE = "";
          Ubuntu = "󰕈";
          Windows = "";
        };
      };

      username = {
        format = "[ $user]($style)";
        show_always = true;
        style_root = "bg:red fg:crust";
        style_user = "bg:red fg:crust";
      };


      directory = {
        format = "[ $path ]($style)";
        style = "bg:peach fg:crust";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      custom.git_branch = {
        command = "starship module git_branch | sd '.*\\s+(\\S+)\\s*.*' '$1'\n";
        description = "Only show git_branch if we're not in a jj repo";
        format = "[[ $symbol $output](fg:crust bg:yellow)]($style)";
        style = "bg:yellow";
        symbol = "";
        when = "! jj --ignore-working-copy root";
      };

      custom.git_status = {
        command = "starship module git_status | sed 's/\\x1b\\[[0-9;]*m//g'\n";
        description = "Only show git_branch if we're not in a jj repo";
        format = "[($output)(fg:crust bg:yellow)]($style)";
        style = "bg:yellow";
        when = "! jj --ignore-working-copy root";
      };

      custom.starship-jj = {
        command = "prompt";
        ignore_timeout = true;
        shell = ["starship-jj" "--ignore-working-copy" "starship"];
        use_stdin = false;
        when = true;
      };

      c = {
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      deno = {
        format = "[[ $symbol ($version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "🦕";
      };

      docker_context = {
        format = "[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)";
        style = "bg:sapphire";
        symbol = "";
      };

      golang = {
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      haskell = {
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      java = {
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      kotlin = {
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      nodejs = {
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      php = {
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      python = {
        format = "[[ $symbol( $version)((#$virtualenv)) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      ruby = {
        format = "[[ $symbol($ version)](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      rust = {
        format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
        style = "bg:green";
        symbol = "";
      };

      conda = {
        format = "[$symbol$environment ]($style)";
        ignore_base = false;
        style = "fg:crust bg:sapphire";
        symbol = "  ";
      };

      time = {
        disabled = false;
        format = "[[  $time ](fg:crust bg:lavender)]($style)";
        style = "bg:lavender";
        time_format = "%R";
      };

      cmd_duration = {
        disabled = false;
        format = " in $duration ";
        min_time_to_notify = 45000;
        show_milliseconds = true;
        show_notifications = true;
        style = "bg:lavender";
      };

      # line_break = {
      #   disable = true;
      # };

      palettes.catppuccin_frappe = {
        base = "#303446";
        blue = "#8caaee";
        crust = "#232634";
        flamingo = "#eebebe";
        green = "#a6d189";
        lavender = "#babbf1";
        mantle = "#292c3c";
        maroon = "#ea999c";
        mauve = "#ca9ee6";
        overlay0 = "#737994";
        overlay1 = "#838ba7";
        overlay2 = "#949cbb";
        peach = "#ef9f76";
        pink = "#f4b8e4";
        red = "#e78284";
        rosewater = "#f2d5cf";
        sapphire = "#85c1dc";
        sky = "#99d1db";
        subtext0 = "#a5adce";
        subtext1 = "#b5bfe2";
        surface0 = "#414559";
        surface1 = "#51576d";
        surface2 = "#626880";
        teal = "#81c8be";
        text = "#c6d0f5";
        yellow = "#e5c890";
      };

      palettes.catppuccin_latte = {
        base = "#eff1f5";
        blue = "#1e66f5";
        crust = "#dce0e8";
        flamingo = "#dd7878";
        green = "#40a02b";
        lavender = "#7287fd";
        mantle = "#e6e9ef";
        maroon = "#e64553";
        mauve = "#8839ef";
        overlay0 = "#9ca0b0";
        overlay1 = "#8c8fa1";
        overlay2 = "#7c7f93";
        peach = "#fe640b";
        pink = "#ea76cb";
        red = "#d20f39";
        rosewater = "#dc8a78";
        sapphire = "#209fb5";
        sky = "#04a5e5";
        subtext0 = "#6c6f85";
        subtext1 = "#5c5f77";
        surface0 = "#ccd0da";
        surface1 = "#bcc0cc";
        surface2 = "#acb0be";
        teal = "#179299";
        text = "#4c4f69";
        yellow = "#df8e1d";
      };

      palettes.catppuccin_macchiato = {
        base = "#24273a";
        blue = "#8aadf4";
        crust = "#181926";
        flamingo = "#f0c6c6";
        green = "#a6da95";
        lavender = "#b7bdf8";
        mantle = "#1e2030";
        maroon = "#ee99a0";
        mauve = "#c6a0f6";
        overlay0 = "#6e738d";
        overlay1 = "#8087a2";
        overlay2 = "#939ab7";
        peach = "#f5a97f";
        pink = "#f5bde6";
        red = "#ed8796";
        rosewater = "#f4dbd6";
        sapphire = "#7dc4e4";
        sky = "#91d7e3";
        subtext0 = "#a5adcb";
        subtext1 = "#b8c0e0";
        surface0 = "#363a4f";
        surface1 = "#494d64";
        surface2 = "#5b6078";
        teal = "#8bd5ca";
        text = "#cad3f5";
        yellow = "#eed49f";
      };

      palettes.catppuccin_mocha = {
        base = "#1e1e2e";
        blue = "#89b4fa";
        crust = "#11111b";
        flamingo = "#f2cdcd";
        green = "#a6e3a1";
        lavender = "#b4befe";
        mantle = "#181825";
        maroon = "#eba0ac";
        mauve = "#cba6f7";
        overlay0 = "#6c7086";
        overlay1 = "#7f849c";
        overlay2 = "#9399b2";
        peach = "#fab387";
        pink = "#f5c2e7";
        red = "#f38ba8";
        rosewater = "#f5e0dc";
        sapphire = "#74c7ec";
        sky = "#89dceb";
        subtext0 = "#a6adc8";
        subtext1 = "#bac2de";
        surface0 = "#313244";
        surface1 = "#45475a";
        surface2 = "#585b70";
        teal = "#94e2d5";
        text = "#cdd6f4";
        yellow = "#f9e2af";
      };
    };
  };
}

