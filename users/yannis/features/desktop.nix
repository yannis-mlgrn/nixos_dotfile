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
    signal-desktop
    obsidian
    vlc
    iptvnator
  ];

  # Thème sombre global (GTK, Qt et préférence freedesktop lue via le portail)
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Adwaita-dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  home.sessionVariables = {
    VISUAL = "codium --wait";
    EDITOR = "codium --wait";
  };
}
