{ config, ... }:
{
  home.shellAliases = {
    g = "git";
    lg = "lazygit";
  };

  # https://nixos.asia/en/git
  programs = {
    git = {
      enable = true;
      ignores = [ "*~" "*.swp" ];
      # Commits are not signed. Setting this also silences a warning about the changed default.
      signing.format = null;
      settings = {
        user.name = config.me.fullname;
        user.email = config.me.email;
        alias.ci = "commit";
        # init.defaultBranch = "master";
        # pull.rebase = "false";
      };
    };
    lazygit.enable = true;
  };
}
