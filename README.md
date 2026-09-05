# ❄️ Configuration NixOS

Configuration NixOS moderne, modulaire et reproductible pour laptop (Dell), basée sur **Nix Flakes**, **Home Manager** et **Agenix**.

L'environnement graphique repose sur **Hyprland** (Wayland) avec **SDDM** (thème `qylock`), un pipeline audio sous **PipeWire**, et une gestion hybride GPU **Nvidia PRIME Offload** (AMD iGPU pour l'affichage bureautique / Nvidia dGPU à la demande).

---

## 📁 Architecture du Dépôt

```text
nixos-config/
├── flake.nix                                 # Point d'entrée Flake (inputs dédupliqués, formatter, devShell)
├── flake.lock                                # Verrouillage reproductible des dépendances
├── statix.toml                               # Configuration du linter Statix
├── .gitlab-ci.yml                            # Pipeline CI/CD (nix flake check & statix)
├── hosts/
│   └── dellYannis/
│       ├── default.nix                       # Configuration de la machine (assemblage des modules)
│       └── hardware-configuration.nix        # Spécificités matérielles et disques (LUKS, SSD)
├── modules/
│   ├── core/
│   │   ├── boot.nix                          # Bootloader (systemd-boot), kernel & firmwares
│   │   ├── locale.nix                        # Fuseau horaire (Europe/Paris), locales fr_FR et clavier azerty
│   │   ├── network.nix                       # NetworkManager, pare-feu & Tailscale
│   │   ├── nix.nix                           # Flakes, GC automatique (14j), déduplication store & licences
│   │   ├── nix-ld.nix                        # nix-ld (openssl, zlib, libstdc++) pour uv et binaires dynamiques
│   │   └── security.nix                      # Bannière issue, OpenSSH durci, PAM hyprlock & rtkit
│   ├── desktop/
│   │   ├── hyprland.nix                      # Hyprland, variables Wayland, portails XDG et paquets desktop
│   │   └── sddm.nix                          # SDDM Qt6/Wayland et thème qylock (windows_7)
│   ├── hardware/
│   │   ├── bluetooth.nix                     # Bluetooth et service Blueman
│   │   ├── nvidia.nix                        # Pilotes Nvidia, PRIME offload et règles udev DRI
│   │   └── sound.nix                         # PipeWire (ALSA, PulseAudio, JACK) et rtkit
│   └── virtualisation/
│       ├── docker.nix                        # Démon et virtualisation Docker
│       └── libvirt.nix                       # Libvirt, Vagrant et dconf
├── users/
│   └── yannis/
│       ├── default.nix                       # Déclaration de l'utilisateur NixOS et shell Zsh
│       └── home.nix                          # Configuration Home Manager (dotfiles, applications, git)
├── secrets/
│   ├── secrets.nix                           # Registre des clés publiques autorisées
│   └── *.age                                 # Secrets chiffrés via age / agenix
└── utils/
    ├── gitlab-sync.nix                       # Service et script CLI sync-gitlab-repos
    └── nextcloud-sync.nix                    # Service et script CLI sync-nextcloud (~/drive)
```

---

## 🛠️ Commandes Usuelles

### 1. Appliquer les changements (Rebuild)

Pour reconstruire et basculer sur la nouvelle configuration système :

```bash
sudo nixos-rebuild switch --flake .
```

Pour tester sans basculer le bootloader par défaut :

```bash
sudo nixos-rebuild test --flake .
```

### 2. Vérification et Qualité de Code

* **Évaluation complète du Flake** (hôtes, devShells, modules) :
  ```bash
  nix flake check
  ```

* **Linter de code Nix** (Statix) :
  ```bash
  nix run nixpkgs#statix -- check
  ```

* **Formater l'ensemble du dépôt** (Alejandra) :
  ```bash
  nix fmt
  ```

### 3. Environnement de Développement (DevShell)

Pour obtenir un shell isolé contenant automatiquement `pkg-config`, `openssl` et les variables d'environnement de compilation (`PKG_CONFIG_PATH`) :

```bash
nix develop
```

### 4. Gestion des Secrets (Agenix)

Éditer ou ajouter un secret chiffré :

```bash
nix run github:ryantm/agenix -- -e secrets/nextcloud-sync-drive.age
```

Pour ré-appliquer les clés après modification de `secrets/secrets.nix` :

```bash
nix run github:ryantm/agenix -- -r
```

---

## 🔒 Maintenance & Sécurité

* **Optimisation du Nix Store** : Le store déduplique automatiquement les fichiers identiques via des liens durs (`auto-optimise-store = true`).
* **Garbage Collection** : Nettoyage automatique hebdomadaire des générations de plus de 14 jours.
* **Intégration Continue (CI)** : Chaque push sur `main` ou merge request exécute `nix flake check` et `statix check` dans GitLab CI.

---

*Maintenu par Yannis — Dernière mise à jour : Septembre 2026*
