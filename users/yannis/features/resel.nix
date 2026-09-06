{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.tio
    inputs.raktools.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."tio/config".text = ''
    [default]
    # Reconnexion automatique si tu débranches/rebranches l'USB
    auto-connect = direct
    databits = 8
    stopbits = 1
    parity = none

    # Profil Cisco Catalyst 2960G
    # - Baudrate standard : 9600
    # - output-line-delay : 150ms pour laisser le temps à Cisco IOS de traiter chaque ligne
    # - output-delay : 5ms entre caractères pour fluidifier l'envoi
    [cisco]
    device = /dev/ttyUSB0
    baudrate = 9600
    output-line-delay = 150
    output-delay = 5

    # Profil MikroTik (RouterBOARD / Cloud Router Switch)
    # - Baudrate par défaut RouterOS : 115200
    # - RouterOS encaisse mieux que l'IOS Cisco, 50ms par ligne suffit largement
    [mikrotik]
    device = /dev/ttyUSB0
    baudrate = 115200
    output-line-delay = 50
  '';

  home.shellAliases = {
    cisco = "tio cisco";
    mikrotik = "tio mikrotik";
  };
}
