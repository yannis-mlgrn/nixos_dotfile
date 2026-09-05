# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Include the results of the hardware scan.
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Import customs files
      ./users/yannis
      #./utils/nextcloud-sync.nix
      #./hardening/default.nix
    ];

  # Legal banner for console and SSH
  environment.etc."issue".text = ''
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

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Auto-load Intel Wi-Fi driver and non-free firmware
  boot.kernelModules = [ "iwlwifi" ];
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "dellYannis";

  # Enable networking (NetworkManager handles Ethernet & Wi-Fi)
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Optionally set static IP for enp3s0 if switch doesn't have a DHCP server:
  # networking.interfaces.enp3s0.ipv4.addresses = [{
  #   address = "192.168.1.50";
  #   prefixLength = 24;
  # }];

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

  # Désactiver GDM et GNOME
  services.xserver.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  # Activer SDDM avec Qt6 / Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
  };

  # Session Wayland par défaut
  services.displayManager.defaultSession = "hyprland";

  programs.qylock = {
    enable = true;
    theme = "windows_7";
  };

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
  security.pam.services.hyprlock = {};

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable Bluetooth and Blueman
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Enable Tailscale
  services.tailscale.enable = true;

  # Enable gnugpg
  programs.gnupg.agent.enable = true;

  # Enable graphics driver
  hardware.graphics.enable = true;

  services.udev.extraRules = ''
    KERNEL=="card*", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", KERNELS=="0000:05:00.0", SYMLINK+="dri/amd-igpu"
    KERNEL=="card*", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-dgpu"
  '';

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
    };
  };

  # Accept sdk license android
  nixpkgs.config.android_sdk.accept_license = true;

  # Accept experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    wget
    vim

    # Hyprland tools & Desktop apps
    waybar
    eww
    dunst
    libnotify
    bemenu
    htop
    kdePackages.dolphin
    brightnessctl
    hyprpaper
    hyprlock
    networkmanagerapplet

    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or []) ++ [ "-Dexperimental=true" ];
    }))

    # Vagrant
    vagrant

   # Avoid C compilation errors
   openssl
   openssl.dev
   pkg-config
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "25.11";

  # age.secrets.nextcloud-drive-credentials = {
  #   file = ./secrets/nextcloud-sync-drive.age;
  #   owner = "yannis";
  #   mode = "600";
  # };

  ## UV Compliance ##
  programs.nix-ld.enable = true;

  ## Docker compliance
  virtualisation.docker = {
    enable = true;
  };

  # Libvirt & Vagrant configuration
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Mitmweb compliance
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Hyprland (sans UWSM)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = false;
  };

  # Environment variables for Wayland + Nvidia + Hyprland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";

    # Nvidia (Commented out to run the desktop environment on the AMD iGPU, saving resources)
    # LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";

    # App configs
    BEMENU_BACKEND = "wayland";
    ZED_RENDERER = "opengl";

    # Openssl
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig"; 
  };

  # Desktop portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Autoriser la modification de la luminosité sans sudo
  services.udev.packages = [ pkgs.brightnessctl ];
}
