{ ... }:

{
  imports = [
    ./kernel.nix
    ./audit.nix
    ./users.nix
  ];

  # Options globales de durcissement
  security.lockKernelModules = true; # Empêche le chargement de modules après boot (R12)
  security.protectKernelImage = true;
  
  # Masquer les autres utilisateurs (R33)
  services.dbus.implementation = "broker"; # Plus moderne/performant
}
