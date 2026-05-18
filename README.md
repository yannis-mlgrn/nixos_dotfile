Configuration NixOS structurée et reproductible, utilisant **Agenix** pour la gestion des secrets et **Home Manager** pour l'environnement utilisateur.

## 📁 Architecture du Dépôt

### 🔑 `/secrets`
Gestion centralisée des données sensibles (mots de passe, clés API).
- **`secrets.nix`** : Registre des destinataires (clés publiques SSH utilisateur et système).
- **`*.age`** : Fichiers chiffrés via `age`. Ils sont déchiffrés automatiquement dans `/run/agenix/` lors du boot.

### 👤 `/users`
Configurations spécifiques par utilisateur.
- **`yannis/default.nix`** : Configuration système (groupes, shell, utilisateur normal).
- **`yannis/home.nix`** : Configuration Home Manager (dotfiles, applications, paramètres desktop).

### 🛠️ `/utils`
Modules et services personnalisés.
- **`nextcloud-sync.nix`** : Service Systemd pour la synchronisation automatique de Nextcloud via `nextcloudcmd`. Utilise les secrets d'Agenix pour l'authentification.

### ⚙️ Racine
- **`configuration.nix`** : Point d'entrée principal de la configuration système.
- **`hardware-configuration.nix`** : Détection matérielle et configuration des partitions (généré).

## 🛠️ Maintenance & Développement

### Environnement de développement
Ce projet inclut un fichier `shell.nix`. Pour obtenir tous les outils nécessaires (age, statix, etc.) :
```bash
nix-shell
```

### Appliquer la configuration
```bash
sudo nixos-rebuild switch
```

### Gestion des secrets
```bash
# Utiliser l'outil agenix (via le shell ou directement)
nix run github:ryantm/agenix -- -e secrets/nom-du-fichier.age
```

---
*Maintenu par Yannis — Dernière mise à jour : 18 Mai 2026*
