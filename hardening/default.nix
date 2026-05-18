{ ... }:

{
  imports = [
    ../anssi
    ./kernel.nix
    ./audit.nix
    ./users.nix
  ];

  # ANSSI Hardening Configuration
  security.anssi = {
    enable = true;
    level = "intermediary";
    category = "client";
    excludes = [ "no-ipv6" ];
    exceptions.R11.rationale = "ptrace_scope est configuré à 2 (plus strict que R11) dans kernel.nix";
    exceptions.R10.rationale = "Géré via security.lockKernelModules dans default.nix";
  };

  # Options globales de durcissement
  security.lockKernelModules = true; # Empêche le chargement de modules après boot (R12)
  security.protectKernelImage = true;
  
  # Masquer les autres utilisateurs (R33)
  services.dbus.implementation = "broker"; # Plus moderne/performant
}
