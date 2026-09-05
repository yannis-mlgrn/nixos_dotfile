{
  pkgs,
  inputs,
  lib,
  ...
}:
# 1. On injecte 'inputs' ici
{
  home.stateVersion = "25.11";

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
    terminator
    impala
    bluetui

    # IMT A
    temurin-bin

    # Desktop
    vscodium
    firefox
    thunderbird
    spotify
    # bitwarden-desktop # Risk issue with electron  39.X
    telegram-desktop
    antigravity-ide
    tailscale
    discord
    obsidian
    openssl
    unzip
    pkg-config
    zed-editor

    # Rust
    rustup
    gcc
    cmake
    gnumake

    # Docker
    docker-compose

    # Internship
    frida-tools
    burpsuite
    uv
    lzip
    ghidra
    ripgrep
    jadx
    android-tools

    #Python
    pipx

    # 2. Utilisation propre de l'input Flake
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
  ];

  home.sessionVariables = {
    GITLAB_HOST = "git.resel.fr";
    GIT_PROTOCOL = "https";
    VISUAL = "codium --wait";
    EDITOR = "codium --wait";
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

  home.shellAliases = {
    agi = "agy";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
