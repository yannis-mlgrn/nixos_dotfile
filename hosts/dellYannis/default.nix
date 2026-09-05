{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../users/yannis

    # Modules système
    ../../modules/core/boot.nix
    ../../modules/core/locale.nix
    ../../modules/core/network.nix
    ../../modules/core/security.nix
    ../../modules/core/nix.nix
    ../../modules/core/nix-ld.nix

    # Modules matériel
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/sound.nix

    # Modules environnement de bureau
    ../../modules/desktop/sddm.nix
    ../../modules/desktop/hyprland.nix

    # Modules virtualisation
    ../../modules/virtualisation/docker.nix
    ../../modules/virtualisation/libvirt.nix
  ];

  networking.hostName = "dellYannis";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Paquets système de base
  environment.systemPackages = with pkgs; [
    wget
    vim
  ];

  # Polices d'écriture
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Utilitaires système
  programs = {
    firefox.enable = true;
    gnupg.agent.enable = true;
  };

  services.printing.enable = true;

  system.stateVersion = "25.11";
}
