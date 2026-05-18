{ pkgs, config, ... }:

{
  home-manager.users.yannis = {
    home.stateVersion = "25.11";

    systemd.user.services.nextcloud-autosync = {
      Unit = {
        Description = "Auto sync Nextcloud vers ~/drive";
        After = [ "network-online.target" ];
      };
      
      Service = {
        EnvironmentFile = config.age.secrets.nextcloud-drive-credentials.path;

        # --- Hardening Xe Iaso / ANSSI ---
        # Le service tourne déjà en tant qu'utilisateur (user-service), 
        # mais on renforce son isolation.
        
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only"; # Besoin de ~/drive
        ReadWritePaths = [ "/home/yannis/drive" ];
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
        SystemCallArchitectures = "native";
        # ---------------------------------

        ExecStart = "${pkgs.writeShellScript "nextcloud-sync-wrapper" ''
          ${pkgs.nextcloud-client}/bin/nextcloudcmd -n -u "$username" -p "$password" /home/yannis/drive/ https://drive.resel.fr
        ''}";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/yannis/drive";
        Restart = "on-failure";
        RestartSec = "30s";
      };
      
      Install.WantedBy = [ "default.target" ];
    };

    systemd.user.timers.nextcloud-autosync = {
      Unit.Description = "Timer pour la synchro Nextcloud";
      Timer = {
        OnBootSec = "5min";
        OnUnitActiveSec = "10min";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}