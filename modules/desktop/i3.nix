{pkgs, ...}: {
  # Activer le serveur X11 et le gestionnaire de fenêtres i3
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock-color
        betterlockscreen
        autotiling
        feh
        picom
        polybarFull
        xclip
        xrandr
        arandr
        autorandr
      ];
    };
  };

  # Gestion automatique des écrans et du hotplug (branchement / débranchement)
  services.autorandr = {
    enable = true;
  };

  # Définir la session par défaut pour SDDM
  services.displayManager.defaultSession = "none+i3";

  # Outils et applications graphiques pour l'environnement i3
  environment.systemPackages = with pkgs; [
    # Fond d'écran & compositeur
    feh
    picom

    # Barre de statut & menus
    polybarFull
    i3status
    dmenu
    bemenu

    # Verrouillage & notifications
    i3lock-color
    betterlockscreen
    autotiling
    dunst
    libnotify

    # Utilitaires système & audio
    brightnessctl
    playerctl
    pavucontrol
    networkmanagerapplet
    xclip
    arandr
    autorandr
    terminator
    kdePackages.dolphin
  ];

  # Autoriser la modification de la luminosité sans sudo
  services.udev.packages = [pkgs.brightnessctl];
}
