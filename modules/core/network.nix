_: {
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [8080]; # Mitmweb
    };
  };

  # Évite de bloquer le démarrage en attendant la synchronisation réseau (~5s économisées)
  systemd.services.NetworkManager-wait-online.enable = false;

  services.tailscale.enable = true;
}
