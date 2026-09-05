{pkgs, ...}: {
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  environment.systemPackages = [
    pkgs.vagrant
  ];
}
