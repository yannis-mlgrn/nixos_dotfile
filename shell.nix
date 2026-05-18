{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "nixos-config-shell";

  nativeBuildInputs = with pkgs; [
    # Secrets management
    age
    
    # Git & DevSecOps
    git
    
    # Nix Quality
    statix
    nix
  ];

  shellHook = ''
    echo "❄️ Welcome to the nixos-config development shell!"
    echo "Available tools: age, statix"
  '';
}
