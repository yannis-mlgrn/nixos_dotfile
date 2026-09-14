{pkgs, ...}: {
  home.packages = with pkgs; [
    # Applications Desktop
    vscodium
    firefox
    thunderbird
    spotify
    # bitwarden-desktop # Risk issue with electron 39.X
    telegram-desktop
    antigravity-ide
    discord
    obsidian
  ];

  home.sessionVariables = {
    VISUAL = "codium --wait";
    EDITOR = "codium --wait";
  };
}
