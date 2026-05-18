{ config, pkgs, ... }:

{
  boot.kernelParams = [
    # Mitigations contre les attaques CPU (Spectre/Meltdown)
    "spectre_v2=on"
    "spec_store_bypass_disable=on"
    "l1tf=flush,nosmt"
    "mds=full,nosmt"
    "tsx=off"
    "mitigations=auto,nosmt" # Niveau renforcé ANSSI : désactive le Hyper-threading (SMT)
    
    # Sécurité mémoire
    "page_poison=1"
    "slub_debug=P"
    "page_alloc.shuffle=1"
  ];

  boot.kernel.sysctl = {
    # Restrictions pointeurs noyau (R11)
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.printk_index_enforcement" = 1;
    
    # Protection PTRACE
    "kernel.yama.ptrace_scope" = 2; # Seul root peut ptrace, ou les enfants
    
    # Réseau (Recommandations ANSSI)
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.conf.all.log_martians" = 1;
    
    # Désactiver eBPF non-privilégié
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
  };
}
