_: {
  boot = {
    loader = {
      systemd-boot.enable = true;
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
    };
  };

  # Swap compressé en RAM ultra-rapide (évite les saturations et ralentissements)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  hardware.enableRedistributableFirmware = true;
}
