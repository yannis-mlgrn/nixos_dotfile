# Gaming adapté de https://heywoodlh.io/linux-gaming-2026/ (nixos/modules/gaming.nix)
# Laptop PRIME : lancer les jeux sur la carte Nvidia via l'option Steam `nvidia-offload %command%`
{pkgs, ...}: {
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    # Proton-GE déclaratif plutôt que le script curl du tuto
    extraCompatPackages = [pkgs.proton-ge-bin];
  };

  # Profil "performance" via power-profiles-daemon pendant le jeu (`gamemoderun %command%`)
  programs.gamemode = {
    enable = true;
    settings.custom = {
      start = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
      end = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced";
    };
  };

  # Micro-compositeur Valve (`gamescope -W 1920 -H 1080 -r 60 -- %command%`)
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.sessionVariables = {
    # Synchro Wine via le module noyau ntsync (moins coûteux qu'esync/fsync)
    PROTON_USE_NTSYNC = "1";
    # DLSS sous Proton
    PROTON_ENABLE_NVAPI = "1";
  };

  boot = {
    kernelModules = ["ntsync"];
    # Le split-lock trap fait saccader plusieurs jeux Proton
    kernel.sysctl."kernel.split_lock_mitigate" = 0;
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "ntsync-udev-rules";
      text = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
      destination = "/etc/udev/rules.d/70-ntsync.rules";
    })
  ];

  environment.systemPackages = with pkgs; [
    mangohud # overlay FPS : `mangohud %command%`
    heroic # Epic / GOG
    umu-launcher
  ];
}
