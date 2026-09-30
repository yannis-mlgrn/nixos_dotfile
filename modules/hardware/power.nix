{pkgs, ...}: {
  # Gestion énergétique CPU & plateforme (compatible AMD P-State EPP)
  services.power-profiles-daemon.enable = true;

  # Service de surveillance batterie et alimentation
  services.upower.enable = true;

  # TRIM automatique hebdomadaire pour préserver la vitesse d'écriture du SSD NVMe
  services.fstrim.enable = true;

  # Priorisation dynamique des processus (maintient l'I/O et le CPU réactifs pour l'interface)
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # Outils système en ligne de commande
  environment.systemPackages = with pkgs; [
    power-profiles-daemon
  ];
}
