{pkgs, ...}: {
  home.packages = with pkgs; [
    frida-tools
    burpsuite
    uv
    lzip
    ghidra
    jadx
    android-tools
  ];
}
