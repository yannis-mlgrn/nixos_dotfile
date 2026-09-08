{
  pkgs,
  inputs,
  ...
}: {
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
    ../../modules/hardware/power.nix

    # Modules environnement de bureau
    ../../modules/desktop/sddm.nix
    ../../modules/desktop/hyprland.nix

    # Modules virtualisation
    ../../modules/virtualisation/docker.nix
    ../../modules/virtualisation/libvirt.nix

    # Utilitaires & Services
    ../../utils/gitlab-sync.nix
    ../../utils/nextcloud-sync.nix
  ];

  networking.hostName = "dellYannis";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # Déclaration du secret agenix pour Gemini
  age.secrets.gemini-api-key = {
    file = ../../secrets/gemini-api-key.age;
    owner = "yannis";
    group = "yannis";
    mode = "0400";
  };

  # Paquets système de base
  environment.systemPackages = with pkgs; [
    wget
    vim
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
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
