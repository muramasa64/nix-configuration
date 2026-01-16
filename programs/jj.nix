{ config, pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Isobe Kazuhiko";
        email = "179515+muramasa64@users.noreply.github.com";
      };

      ui = {
        diff-editor = ":builtin";
        default-command = "st";
        editor = "nvim";
        pager = "delta";
        diff-formatter = ":git";
      };

      git = {
        private-commits = "description(glob:\"private:*\")";
      };

      templates = {
        draft_commit_description = ''
          concat(
            description,
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            surround(
              "\nJJ: This commit contains the following patches:\n", "",
              indent("JJ:     ", diff.git()),
            ),
          )
        '';
      };

      revsets = {
        log = "present(immutable_heads()..@) | ancestors(immutable_heads().., 3) | present(trunk()) | present(bookmarks())";
      };

      revset-aliases = {
        "immutable_heads()" = "builtin_immutable_heads() | (trunk().. & ~mine())";
      };
    };
  };
}

