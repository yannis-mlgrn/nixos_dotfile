_: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = ["iwlwifi"];
    kernelParams = [
      "i8042.reset"
      "i8042.nomux=1"
      "i8042.nopnp"
    ];
  };

  hardware.enableRedistributableFirmware = true;
}
