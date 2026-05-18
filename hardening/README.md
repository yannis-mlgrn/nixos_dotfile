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
systemd-analyze --user security nextcloud-autosync.service
```

### Consulter les journaux d'audit
```bash
sudo ausearch -m execve -ts recent
```

## 🧪 Conformité ANSSI

Le système intègre un module de conformité automatisé basé sur les recommandations de l'ANSSI.

### Tester la conformité en temps réel
Un script de vérification est généré à chaque reconstruction du système. Il compare l'état actuel de la machine avec les règles activées.
```bash
sudo anssi-nixos-compliance-check
```
*Note : Certaines vérifications nécessitent les privilèges root pour accéder aux paramètres noyau (`sysctl`, `procfs`).*

### Générer un rapport d'audit
Un rapport détaillé au format JSON est produit lors du build. Il contient la liste des règles appliquées, les exceptions documentées et les références ANSSI.
```bash
# Pour localiser le rapport dans le store Nix
ls $(nix-instantiate --eval -E '(import <nixpkgs> {}).nixos { configuration = import /etc/nixos/configuration.nix; }).config.system.build.complianceReportDocument' | xargs cat
```
