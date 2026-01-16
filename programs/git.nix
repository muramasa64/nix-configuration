{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Isobe Kazuhiko";
        email = "179515+muramasa64@users.noreply.github.com";
      };
      filter = {
        "media" = {
          clean = "git-media-clean %f";
          smudge = "git-media-smudge %f";
        };
      };
      core = {
        precomposeunicode = true;
        quotepath = false;
        editor = "vim -c \"set fenc=utf-8\"";
        pager = "delta";
      };
      alias = {
        st = "status --branch --short";
        l = "log --decorate --stat --patch";
        co = "checkout";
        cv = "commit -v";
        n = "now --all --stat";
        b = "branch";
        graph = "log --graph --date-order -C -M --pretty=format:\"<%h> %ad [%an] %Cgreen%d%Creset %s\" --date=short";
      };
      push = {
        default = "simple";
      };
      pull = {
        "rebase" = true;
      };
      color = {
        ui = "auto";
        "diff-highlight" = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHighlight = "green bold 22";
        };
      };
      merge = {
        defaultToUpstream = true;
        ff = false;
        conflictstyle = "diff3";
      };
      branch = {
        "master" = {
          mergeoptions = "--no-ff";
          rebase = true;
        };
      };
      rebase = {
        autosquash = true;
      };
      filter = {
        "lfs" = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
      log = {
        date = "iso";
      };
      init = {
        defaultBranch = "main";
      };
      secrets = {
        providers = "git secrets --aws-provider";
        patterns = [
          "(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}"
          "(\"|')?(AWS|aws|Aws)?_?(SECRET|secret|Secret)?_?(ACCESS|access|Access)?_?(KEY|key|Key)(\"|')?\\s*(:|=>|=)\\s*(\"|')?[A-Za-z0-9/\\+=]{40}(\"|')?"
          "(\"|')?(AWS|aws|Aws)?_?(ACCOUNT|account|Account)_?(ID|id|Id)?(\"|')?\\s*(:|=>|=)\\s*(\"|')?[0-9]{4}\\-?[0-9]{4}\\-?[0-9]{4}(\"|')?"
        ];
        allowed = [
          "AKIAIOSFODNN7EXAMPLE"
          "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        ];
      };
      delta = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
      diff = {
        colorMoved = "default";
      };
    };
    ignores = [
      ".DS_Store"
      "~$*.xls[x]"
      "*.swp"
      ".*.un~"
      "*~"
      "/vendor/bundle/"
      "*-py-venv/*"
      "terraform.tfstate*"
      ".terraform"
      "*.tfvars"
      "packaged.yaml"
      "node_modules/"
      "__pycache__/"
      ".mise.toml"
      ".jj"
      ".envrc"
      ".direnv/**"
    ];
  };
}
