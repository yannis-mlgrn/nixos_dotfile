{ pkgs, inputs, ... }: # 1. On injecte 'inputs' ici

{
  home.stateVersion = "25.11";

  # Configuration de Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Yannis";
        email = "yannismalgorn@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  home.packages = with pkgs; [
    git-credential-oauth
    terminator

    # Desktop
    vscodium
    firefox
    # bitwarden-desktop # Risk issue with electron  39.X
    telegram-desktop
    antigravity
    gemini-cli
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

    # 2. Utilisation propre de l'input Flake
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
  ];

  home.shellAliases = {
    agi = "agy";
  };
}
