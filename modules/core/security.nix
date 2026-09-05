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
    pam.services.hyprlock = {};
  };
}
