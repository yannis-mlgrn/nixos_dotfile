_: {
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [8080]; # Mitmweb
    };
  };

  services.tailscale.enable = true;
}
