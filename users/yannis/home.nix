{ pkgs, ... }:

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
    bitwarden-desktop
    telegram-desktop
    antigravity
    gemini-cli
    tailscale
    discord
    obsidian

    # Rust7
    rustup
    gcc
    cmake
    gnumake

    # For the intership
    android-studio
    android-tools
    frida-tools
    burpsuite
    uv
    lzip
    ghidra   
    jadx
    quark
    apksigner
    apktool
    (builtins.getFlake "github:jacopone/antigravity-nix").packages.${pkgs.system}.google-antigravity-cli
  ];

  home.shellAliases = {
    agi = "agy";
  };

}
