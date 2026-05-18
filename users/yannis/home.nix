{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  # Configuration de Git
  programs.git = {
      enable = true;
      userName = "Yannis";
      userEmail = "yannismalgorn@gmail.com";
      
      extraConfig = {
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
    antigravity
    gemini-cli

    # For the intership
    android-studio
  ];

}