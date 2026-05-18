# 🛡️ Hardening - Conformité ANSSI & Isolation

Ce répertoire contient la configuration de durcissement (hardening) du système, basée sur les recommandations **ANSSI-BP-028** (via le projet Sécurix) et les principes d'isolation de services.

## 📑 Structure

### 🔒 `kernel.nix`
Configuration du noyau Linux pour minimiser la surface d'attaque.
- **Mitigations CPU** : Protection contre Spectre, Meltdown, L1TF, MDS. Le SMT (Hyper-threading) est désactivé pour une sécurité maximale.
- **Sysctl** : Restrictions sur `dmesg`, `kptr`, et le sous-système eBPF.
- **Réseau** : Durcissement de la pile IP (refus des source-routing, redirections, etc.).

### 📝 `audit.nix`
Journalisation avancée via `auditd`.
- Surveillance des appels système `execve` (exécution de programmes).
- Traçabilité des modifications sur `/etc/sudoers` et `/etc/passwd`.
- Alerte sur les accès au répertoire des secrets déchiffrés.

### 👥 `users.nix` & Isolation
Gestion des privilèges et isolation des processus.
- **Sudo** : Restriction stricte au groupe `wheel` avec réinitialisation de l'environnement.
- **Sandboxing Systemd** : Utilisation du pattern "One Account Per Service" (Xe Iaso). Chaque service critique est enfermé dans un bac à sable avec :
  - `ProtectSystem=strict` : Système de fichiers en lecture seule.
  - `CapabilityBoundingSet=""` : Aucune capacité noyau accordée.
  - `PrivateTmp`, `PrivateDevices` : Isolation des dossiers temporaires et périphériques.

## 🚀 Utilisation

Les modules sont automatiquement importés via `hardening/default.nix` dans la configuration principale.

### Vérifier la sécurité d'un service
```bash
systemctl --user analyze security nextcloud-autosync
```

### Consulter les journaux d'audit
```bash
sudo ausearch -m execve -ts recent
```
