_: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # Démarre à la demande via socket (économise ~10s au boot)
  };
}
