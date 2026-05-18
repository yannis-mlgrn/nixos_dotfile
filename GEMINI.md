# 🧠 Project Instructions (GEMINI.md)

## 🏛️ Architecture & Conventions

### Secrets (Agenix)
- **Destinataires** : Les secrets sont chiffrés pour la clé SSH de l'utilisateur (`~/.ssh/id_ed25519`) et la clé hôte du système (`/etc/ssh/ssh_host_ed25519_key.pub`).
- **Restriction YubiKey** : Les clés `sk-ssh-ed25519` ne sont pas supportées par `age` pour le *chiffrement*. Utiliser uniquement la clé ED25519 standard dans `secrets.nix`.
- **Injection** : Les services doivent lire les credentials depuis `/run/agenix/` via l'option `EnvironmentFile` ou `credentials`.
- **Sécurité** : Les secrets ne doivent JAMAIS être commités en clair. Utiliser uniquement des fichiers `.age`.

## 🔄 Workflows de Maintenance

### Mise à jour des identifiants Nextcloud
1. Générer un **Mot de passe d'application** sur l'instance Nextcloud.
2. Mettre à jour le secret : `nix run github:ryantm/agenix -- -e secrets/nextcloud-sync-drive.age`.
3. Appliquer : `sudo nixos-rebuild switch`.
4. Redémarrer le service : `systemctl --user restart nextcloud-autosync`.

### Erreur 429 (Too Many Requests)
Si le service Nextcloud échoue avec une erreur 429 après plusieurs tentatives infructueuses :
1. Stopper le service : `systemctl --user stop nextcloud-autosync`.
2. Attendre 15 minutes.
3. Vérifier le mot de passe dans `/run/agenix/nextcloud-drive-credentials`.
4. Relancer : `systemctl --user start nextcloud-autosync`.
