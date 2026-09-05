{pkgs, ...}: {
  # Activer X11 pour le display manager
  services.xserver.enable = true;

  # SDDM avec Qt6 / Wayland
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
    };
    defaultSession = "hyprland";
  };

  # Thème qylock pour SDDM
  programs.qylock = {
    enable = true;
    theme = "windows_7";
  };
}
