{ config, pkgs, ... }:

{
  boot.kernelParams = [
    # Compléments aux mitigations ANSSI
    "tsx=off"
    "mitigations=auto,nosmt"
  ];

  boot.kernel.sysctl = {
    "kernel.printk_index_enforcement" = 1;
    
    # Configuration PTRACE (on garde le niveau 2 plus restrictif que R11)
    "kernel.yama.ptrace_scope" = 2;
    
    # Réseau compléments
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.conf.all.log_martians" = 1;
  };
}
