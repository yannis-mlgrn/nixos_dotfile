{ config, pkgs, ... }:

{
  # Sécurité Sudo (R50)
  security.sudo.execWheelOnly = true; # Seul le groupe wheel peut utiliser sudo
  security.sudo.extraConfig = ''
    Defaults env_reset, timestamp_timeout=5
  '';

  # Protection des services (pattern Xe Iaso / ANSSI)
  # On définit une fonction pour durcir n'importe quel service
  # systemd.services.EXAMPLE.serviceConfig = config.hardening.serviceDefaults;

  # Exemple d'implémentation "One Account Per Service" pour Nextcloud Sync
  # (Sera intégré dans utils/nextcloud-sync.nix via imports)
}
