{pkgs, ...}: {
  home.packages = with pkgs; [
    # C / C++ & Build tools
    gcc
    cmake
    gnumake
    pkg-config
    openssl
    terminator

    # Rust
    cargo
    rustc
    rust-analyzer

    # Node.js
    nodejs

    # Docker
    docker-compose

    # Éditeurs
    zed-editor
  ];
}
