{pkgs, ...}: {
  home.packages = with pkgs; [
    # C / C++ & Build tools
    gcc
    cmake
    gnumake
    pkg-config
    openssl
    terminator

    #homelab
    k9s
    kubectl

    # Rust
    cargo
    rustc
    rust-analyzer

    # Node.js
    nodejs_26

    # Docker
    docker-compose

    # Éditeurs
    zed-editor
  ];
}
