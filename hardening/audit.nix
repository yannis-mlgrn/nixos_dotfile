{ config, pkgs, ... }:

{
  # Activation de l'audit système (R33)
  security.auditd.enable = true;
  security.audit.enable = true;

  # Règles de base ANSSI
  security.audit.rules = [
    # Surveiller les exécutions de programmes
    "-a exit,always -F arch=b64 -S execve"
    "-a exit,always -F arch=b32 -S execve"
    
    # Surveiller les modifications de privilèges (sudo/chown)
    "-w /etc/sudoers -p wa -k scope-privilege"
    "-w /etc/passwd -p wa -k scope-auth"
    
    # Surveiller les accès aux secrets (si déchiffrés)
    "-w /run/agenix/ -p wa -k scope-secrets"
  ];
}
