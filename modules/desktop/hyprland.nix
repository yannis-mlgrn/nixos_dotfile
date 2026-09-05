{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = false;
  };

  # Variables d'environnement pour Wayland & Hyprland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";

    # App configs
    BEMENU_BACKEND = "wayland";
    BEMENU_OPTS = "--no-overlap -W 1 -H 26 --hp 6 -i --wrap --fn 'JetBrainsMono Nerd Font 11' --tb '#101018' --tf '#8caaee' --fb '#101018' --ff '#c6d0f5' --nb '#101018' --nf '#c6d0f5' --hb '#313244' --hf '#99d1db' --sb '#313244' --sf '#99d1db' --scb '#101018' --scf '#8caaee' --bdr '#313244' -B 1 -p ' 󰀻 Run: '";
    ZED_RENDERER = "opengl";
  };

  # Portails de bureau XDG
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Outils et applications graphiques pour Hyprland
  environment.systemPackages = with pkgs; [
    eww
    dunst
    libnotify
    bemenu
    htop
    kdePackages.dolphin
    brightnessctl
    hyprpaper
    hyprlock
    networkmanagerapplet

    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or []) ++ ["-Dexperimental=true"];
    }))
  ];

  # Autoriser la modification de la luminosité sans sudo
  services.udev.packages = [pkgs.brightnessctl];
}
