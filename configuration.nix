# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Include the results of the hardware scan.
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Import customs files
      ./users/yannis/default.nix
      ./utils/nextcloud-sync.nix
      ./hardening/default.nix

      #Import Modules
      <home-manager/nixos>
      <agenix/modules/age.nix>
    ];

  # Legal banner for console and SSH
  environment.etc."issue".text = ''
    ***************************************************************************
    *                                                                         *
    *                      UNAUTHORIZED ACCESS PROHIBITED                     *
    *                                                                         *
    *  This system is for authorized users only. All activities are logged.   *
    *  By continuing, you consent to monitoring. Unauthorized access will be  *
    *  prosecuted to the full extent of the law.                              *
    *                                                                         *
    ***************************************************************************
  '';
  environment.etc."issue.net".text = config.environment.etc."issue".text;

  # Openssh config
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

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dellYannis";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Enable graphics driver
  hardware.graphics.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # nvidia-x11 open source drivers).
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # lspci | grep -E "VGA|3D"
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
    };
  };

  # Accept sdk license android
  nixpkgs.config.android_sdk.accept_license = true;

  # Accept experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  system.stateVersion = "25.11";

  age.secrets.nextcloud-drive-credentials = {
    file = ./secrets/nextcloud-sync-drive.age;
    owner = "yannis";
    mode = "600";
  };

}
