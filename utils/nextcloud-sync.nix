{
  pkgs,
  config,
  ...
}: let
  syncNextcloud = pkgs.writeShellScriptBin "sync-nextcloud" ''
    set -euo pipefail

    # Charger les identifiants déchiffrés par agenix
    if [ -f /run/agenix/nextcloud-drive-credentials ]; then
      set -a
      source /run/agenix/nextcloud-drive-credentials
      set +a
    fi

    if [ -z "''${username:-}" ] || [ -z "''${password:-}" ]; then
      echo "Erreur : Identifiants Nextcloud introuvables (/run/agenix/nextcloud-drive-credentials introuvable ou incomplet)." >&2
      exit 1
    fi

    LOCAL_DIR="''${HOME:-/home/yannis}/drive"
    SERVER_URL="https://drive.resel.fr"

    echo "=== Synchronisation Nextcloud ($SERVER_URL -> $LOCAL_DIR) ==="

    # 1. Vérification réseau
    if ! ${pkgs.iputils}/bin/ping -c 1 -W 2 "drive.resel.fr" >/dev/null 2>&1; then
      echo "Serveur drive.resel.fr injoignable, synchronisation reportée."
      exit 0
    fi

    # 2. Préparation des répertoires
    ${pkgs.coreutils}/bin/mkdir -p "$LOCAL_DIR" "''${HOME:-/home/yannis}/.config/Nextcloud"

    # 3. Transmission sécurisée des identifiants via l'environnement (non visibles dans ps aux)
    export NC_USER="$username"
    export NC_PASSWORD="$password"

    # 4. Synchronisation non-interactive avec fichier d'exclusion standard
    ${pkgs.nextcloud-client}/bin/nextcloudcmd \
      --non-interactive \
      --exclude ${pkgs.nextcloud-client}/etc/Nextcloud/sync-exclude.lst \
      "$@" \
      "$LOCAL_DIR/" \
      "$SERVER_URL"

    echo "=== Synchronisation Nextcloud terminée avec succès ==="
  '';
in {
  # Déclaration du secret agenix pour Nextcloud Drive
  age.secrets.nextcloud-drive-credentials = {
    file = ../secrets/nextcloud-sync-drive.age;
    owner = "yannis";
    group = "yannis";
    mode = "0400";
  };

  # Commande CLI disponible dans le système (ex: `sync-nextcloud` ou `sync-nextcloud -s`)
  environment.systemPackages = [
    syncNextcloud
  ];

  home-manager.users.yannis = {
    systemd.user.services.nextcloud-autosync = {
      Unit = {
        Description = "Auto sync Nextcloud vers ~/drive";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        Type = "oneshot";
        TimeoutStartSec = "600s";
        EnvironmentFile = config.age.secrets.nextcloud-drive-credentials.path;

        # --- Hardening Xe Iaso / ANSSI ---
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ReadWritePaths = [
          "/home/yannis/drive"
          "/home/yannis/.config/Nextcloud"
        ];
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        LockPersonality = true;
        SystemCallFilter = ["@system-service"];
        SystemCallArchitectures = "native";
        # ---------------------------------

        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/yannis/drive /home/yannis/.config/Nextcloud";
        ExecStart = "${syncNextcloud}/bin/sync-nextcloud -s";
      };
    };

    systemd.user.timers.nextcloud-autosync = {
      Unit.Description = "Timer pour la synchronisation automatique Nextcloud vers ~/drive";
      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "10min";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
