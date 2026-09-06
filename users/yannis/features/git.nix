{
  pkgs,
  lib,
  ...
}: {
  # Configuration de Git
  programs.git = {
    enable = true;

    signing = {
      key = "AE83A6FDBDBCD071";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Yannis";
        email = "yannismalgorn@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      credential."https://git.resel.fr" = {
        helper = "!f() { [ -f /run/agenix/gitlab-token ] && . /run/agenix/gitlab-token; echo username=oauth2; echo password=\"$GITLAB_TOKEN\"; }; f";
      };
    };
  };

  home.packages = with pkgs; [
    git-credential-oauth
    glab
  ];

  home.sessionVariables = {
    GITLAB_HOST = "git.resel.fr";
    GIT_PROTOCOL = "https";
    GLAB_CHECK_UPDATE = "false";
  };

  # Configuration déclarative de glab avec permissions 0600 requises par l'outil
  home.activation.setupGlabConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "$HOME/.config/glab-cli"
        cat << 'EOF' > "$HOME/.config/glab-cli/config.yml"
    git_protocol: https
    editor: codium --wait
    glamour_style: dark
    check_update: false
    host: git.resel.fr
    hosts:
      git.resel.fr:
        api_host: git.resel.fr
        git_protocol: https
    EOF
        chmod 600 "$HOME/.config/glab-cli/config.yml"
  '';
}
