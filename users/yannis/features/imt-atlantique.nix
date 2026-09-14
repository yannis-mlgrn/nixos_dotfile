{pkgs, ...}: {
  home.packages = with pkgs; [
    temurin-bin
    octaveFull # Projets Matlab
  ];
}
