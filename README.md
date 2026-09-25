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
├── .gitlab-ci.yml                            # Pipeline CI/CD DevSecOps (Gitleaks, Alejandra, Statix, Deadnix, eval)
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
│   │   ├── power.nix                         # Profils énergétiques (power-profiles-daemon) et UPower
│   │   └── sound.nix                         # PipeWire (ALSA, PulseAudio, JACK) et rtkit
│   └── virtualisation/
│       ├── docker.nix                        # Démon et virtualisation Docker
│       ├── libvirt.nix                       # Libvirt, Vagrant et dconf
│       └── virtualbox.nix                    # VirtualBox et packs d'extension
├── users/
│   └── yannis/
│       ├── default.nix                       # Déclaration de l'utilisateur NixOS, groupes (dialout) et shell Zsh
│       ├── home.nix                          # Point d'entrée Home Manager modulaire (assemblage des features)
│       └── features/                         # Modules atomiques (cli, desktop, dev, git, imt-atlantique, resel, internship)
├── secrets/
│   ├── secrets.nix                           # Registre des clés publiques autorisées
│   └── *.age                                 # Secrets chiffrés via age / agenix
└── utils/
    ├── gitlab-sync.nix                       # Service et script CLI sync-gitlab-repos
    └── nextcloud-sync.nix                    # Service et script CLI sync-nextcloud (~/drive)
```

---

## 🛠️ Commandes Usuelles

### 1. Appliquer les changements (Rebuild avec nh & nvd)

Grâce à **`nh`** (Nix Helper) configuré avec le flake par défaut et **`nvd`** intégré :

```bash
# Rebuild et affichage visuel du diff des paquets avant bascule
nh os switch

# Tester temporairement sans impacter le bootloader
nh os test
```

*(La commande classique reste `sudo nixos-rebuild switch --flake .`)*

### 2. Vérification et Qualité de Code

* **Formater l'ensemble du dépôt** (Alejandra) :
  ```bash
  nix fmt
  ```

* **Linter de code Nix** (Statix) :
  ```bash
  nix run nixpkgs#statix -- check
  ```

* **Détection de code mort** (Deadnix) :
  ```bash
  nix run nixpkgs#deadnix -- --fail .
  ```

* **Détection de fuites de secrets** (Gitleaks) :
  ```bash
  nix run nixpkgs#gitleaks -- detect --verbose --redact
  ```

* **Évaluation complète du Flake** (hôtes, devShells, modules) :
  ```bash
  nix flake check
  ```

* **Tester le pipeline CI en local** (gitlab-ci-local) :
  ```bash
  gitlab-local-ci
  # ou cibler un job : gitlab-local-ci secret-detection
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
* **Pipeline CI/CD DevSecOps** : Chaque push sur `main` ou merge request exécute :
  * La recherche de fuites de secrets (**Gitleaks**).
  * Le respect du style et l'analyse statique (**Alejandra**, **Statix**, **Deadnix**).
  * La vérification et l'évaluation rapide de la dérivation système (**nix flake check** & **nix eval**).

---

*Maintenu par Yannis — Dernière mise à jour : Septembre 2026*
