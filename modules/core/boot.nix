_: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false; # Empêche init=/bin/sh au menu de boot (root sans mot de passe)
      };
      efi.canTouchEfiVariables = true;
      timeout = 5; # 5 secondes pour pouvoir sélectionner une génération précédente en cas de problème
    };
    kernelModules = ["iwlwifi"];
    kernelParams = [
      "i8042.reset"
      "i8042.nomux=1"
      "i8042.nopnp"
    ];

    # Optimisation de la mémoire virtuelle pour ZRAM
    kernel.sysctl = {
      "vm.swappiness" = 100;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;

      # Durcissement réseau / noyau (ptrace et kptr laissés par défaut pour gdb/RE)
      "kernel.dmesg_restrict" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
    };
  };

  # Swap compressé en RAM ultra-rapide (évite les saturations et ralentissements)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  boot.tmp.cleanOnBoot = true;

  hardware.enableRedistributableFirmware = true;

  # Mises à jour firmware/BIOS Dell via LVFS (fwupdmgr update)
  services.fwupd.enable = true;
}
