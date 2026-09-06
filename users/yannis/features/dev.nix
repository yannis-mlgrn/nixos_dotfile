{pkgs, ...}: {
  home.packages = with pkgs; [
    # C / C++ & Build tools
    gcc
    cmake
    gnumake
    pkg-config
    openssl

    # Rust
    rustup

    # Docker
    docker-compose

    # Éditeurs
    zed-editor
  ];
}
