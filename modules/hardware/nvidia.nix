{config, ...}: {
  hardware.graphics.enable = true;

  services.udev.extraRules = ''
    KERNEL=="card*", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", KERNELS=="0000:05:00.0", SYMLINK+="dri/amd-igpu"
    KERNEL=="card*", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-dgpu"
  '';

  # Pilotes Nvidia pour Xorg et Wayland
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
}
