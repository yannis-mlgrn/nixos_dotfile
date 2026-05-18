Configuration NixOS structurée et reproductible, mettant l'accent sur la sécurité (conforme ANSSI) et l'automatisation. Elle utilise **Agenix** pour les secrets et **Home Manager** pour l'environnement utilisateur.

## 📁 Architecture du Dépôt

### 🛡️ `/hardening` & `/anssi`
Cœur de la sécurité du système.
- **`/anssi`** : Module NixOS implémentant les recommandations de sécurité de l'ANSSI (v2.0).
- **`/hardening`** : Configuration locale de durcissement (Kernel, Audit, Users) intégrant le module ANSSI au niveau **reinforced**.

### 🔑 `/secrets`
Gestion centralisée des données sensibles.
- **`secrets.nix`** : Registre des clés publiques autorisées.
- **`*.age`** : Secrets chiffrés via `age`, injectés dans `/run/agenix/`.

### 👤 `/users`
- **`yannis/`** : Configuration système et Home Manager (dotfiles, applications GNOME) pour l'utilisateur principal.

### 🛠️ `/utils`
- **`nextcloud-sync.nix`** : Service de synchronisation automatique utilisant les secrets Agenix.

### ⚙️ Racine
- **`configuration.nix`** : Point d'entrée principal.
- **`hardware-configuration.nix`** : Configuration spécifique au matériel (Dell laptop).

## 🔒 Sécurité & Conformité

Le système est durci selon les recommandations de l'ANSSI (v2.0). Contrairement à une configuration manuelle, cette approche utilise un **moteur de règles dynamique**.

### Fonctionnement du module
Le module ANSSI (`/anssi`) automatise le cycle de sécurité :

1.  **Déclaration des règles** : Les recommandations (R8, R9, etc.) sont centralisées dans `ruleset.nix`.
2.  **Moteur de génération** : `generator.nix` transforme ces règles en options NixOS réelles. Il calcule automatiquement quelles règles activer selon le `level` (ex: `reinforced`) et la `category` (ex: `client`) choisis.
3.  **Application atomique** : Lors du `nixos-rebuild`, les paramètres (Kernel, Sysctl) sont fusionnés au système.
4.  **Audit intégré** : Le module génère dynamiquement un script de vérification basé sur votre configuration active.

### Vérifier la conformité
Utilisez l'outil de diagnostic pour valider l'application des règles :
```bash
sudo anssi-nixos-compliance-check
```

### Ajuster le durcissement
La configuration se gère dans `hardening/default.nix`. Vous pouvez :
- Changer le niveau : `level = "minimal" | "intermediary" | "reinforced" | "high"`.
- Exclure des tags : `excludes = [ "no-ipv6" ]`.
- Déclarer des exceptions : `exceptions.RXX.rationale = "..."`.

## 🛠️ Maintenance & Développement

### Environnement de travail
```bash
nix-shell
```

### Appliquer les changements
```bash
sudo nixos-rebuild switch -I nixos-config=/home/yannis/nixos-config/configuration.nix
```

### Gestion des secrets
```bash
# Édition d'un secret existant
nix run github:ryantm/agenix -- -e secrets/nextcloud-sync-drive.age
```

---
*Maintenu par Yannis — Dernière mise à jour : Mai 2026*
