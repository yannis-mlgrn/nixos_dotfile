{pkgs, ...}: {
  ## UV & Dynamic Binaries (nix-ld) ##
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
    ];
  };
}
