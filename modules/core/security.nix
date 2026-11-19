{config, ...}: {
  # Bannière légale pour la console et SSH
  environment.etc = {
    "issue".text = ''
      ***************************************************************************
      *                                                                         *
      *                        UNAUTHORIZED ACCESS PROHIBITED                   *
      *                                                                         *
      *  This system is for authorized users only. All activities are logged.   *
      *  By continuing, you consent to monitoring. Unauthorized access will be *
      *  prosecuted to the full extent of the law.                              *
      *                                                                         *
      ***************************************************************************
    '';
    "issue.net".text = config.environment.etc."issue".text;
  };

  # Configuration OpenSSH durcie
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      MaxAuthTries = 3;
      AllowTcpForwarding = false;
      AllowAgentForwarding = false;
      LogLevel = "VERBOSE";
    };
  };

  security = {
    rtkit.enable = true;
    sudo.execWheelOnly = true;
    pam.services.hyprlock = {};
    # Déverrouillage automatique du Secret Service au login (requis par Coucou pour les clés API)
    pam.services.sddm.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  # Verrouillage auto à l'inactivité (DPMS X11) et avant la mise en veille
  programs.xss-lock = {
    enable = true;
    lockerCommand = "/home/yannis/.config/i3/scripts/lock.sh";
  };
}
