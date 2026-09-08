{pkgs, ...}: {
  # Gestion énergétique CPU & plateforme (compatible AMD P-State EPP)
  services.power-profiles-daemon.enable = true;

  # Service de surveillance batterie et alimentation
  services.upower.enable = true;

  # Outils système en ligne de commande
  environment.systemPackages = with pkgs; [
    power-profiles-daemon
  ];
}
