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