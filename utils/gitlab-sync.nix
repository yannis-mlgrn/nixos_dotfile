{
  pkgs,
  config,
  ...
}: let
  syncGitlabRepos = pkgs.writeShellScriptBin "sync-gitlab-repos" ''
    set -euo pipefail

    # Toujours charger le token agenix en priorité pour écraser toute variable obsolète dans l'environnement
    if [ -f /run/agenix/gitlab-token ]; then
      set -a
      source /run/agenix/gitlab-token
      set +a
    fi

    # Emplacement local racine des projets
    DEST_DIR="$HOME/Documents/gitlab"
    GITLAB_HOST="git.resel.fr"
    export GITLAB_HOST
    export GIT_PROTOCOL="https"

    mkdir -p "$DEST_DIR"

    # 1. Vérification réseau
    if ! ${pkgs.iputils}/bin/ping -c 1 -W 2 "$GITLAB_HOST" >/dev/null 2>&1; then
      echo "Serveur $GITLAB_HOST injoignable, synchronisation reportée."
      exit 0
    fi

    # Commande Git avec credential helper intégré pour authentification automatique HTTPS par token
    GIT_CMD="${pkgs.git}/bin/git -c credential.helper='!f() { echo username=oauth2; echo password=\"$GITLAB_TOKEN\"; }; f'"

    TO_CLONE=()
    TO_UPDATE=()

    echo "=== Recherche des projets favoris (starred) sur $GITLAB_HOST ==="

    while IFS=$'\t' read -u 3 -r path_with_ns http_url; do
      [ -z "$path_with_ns" ] && continue
      [ "$path_with_ns" = "null" ] && continue
      [ -z "$http_url" ] && continue
      [ "$http_url" = "null" ] && continue

      # Renommage spécifique : ymalgorn1 sur GitLab -> ymalgorn en local
      local_rel_path="''${path_with_ns/#ymalgorn1/ymalgorn}"
      target_dir="$DEST_DIR/$local_rel_path"

      entry="$(printf '%s\t%s\t%s\t%s' "$path_with_ns" "$http_url" "$target_dir" "$local_rel_path")"
      if [ ! -d "$target_dir/.git" ]; then
        TO_CLONE+=("$entry")
      else
        TO_UPDATE+=("$entry")
      fi
    done 3< <(${pkgs.glab}/bin/glab api --hostname "$GITLAB_HOST" "projects?starred=true&per_page=100" --paginate 2>/dev/null | ${pkgs.jq}/bin/jq -r 'if type == "array" then .[] | select(.path_with_namespace != null and .path_with_namespace != "null") | "\(.path_with_namespace)\t\(.http_url_to_repo)" else empty end')

    NUM_TO_CLONE="''${#TO_CLONE[@]}"
    NUM_TO_UPDATE="''${#TO_UPDATE[@]}"
    TOTAL_PROJECTS=$((NUM_TO_CLONE + NUM_TO_UPDATE))

    echo "Total projets favoris : $TOTAL_PROJECTS ($NUM_TO_CLONE à télécharger, $NUM_TO_UPDATE déjà présents)"

    # Notification initiale indiquant le nombre de projets à télécharger
    if [ -x "${pkgs.libnotify}/bin/notify-send" ]; then
      if [ "$NUM_TO_CLONE" -gt 0 ]; then
        ${pkgs.libnotify}/bin/notify-send -u normal "GitLab Sync" "$NUM_TO_CLONE projet(s) favori(s) à télécharger (sur $TOTAL_PROJECTS favoris)" || true
      elif [ "$TOTAL_PROJECTS" -gt 0 ]; then
        ${pkgs.libnotify}/bin/notify-send -u low "GitLab Sync" "0 projet à télécharger ($TOTAL_PROJECTS favoris déjà présents, synchronisation en cours...)" || true
      else
        ${pkgs.libnotify}/bin/notify-send -u low "GitLab Sync" "Aucun projet favori trouvé sur $GITLAB_HOST." || true
      fi
    fi

    # 1. Téléchargement des nouveaux dépôts
    CLONED_SUCCESS=0
    CLONE_INDEX=0
    if [ "$NUM_TO_CLONE" -gt 0 ]; then
      for item in "''${TO_CLONE[@]}"; do
        IFS=$'\t' read -r path_with_ns http_url target_dir local_rel_path <<< "$item"
        CLONE_INDEX=$((CLONE_INDEX + 1))
        echo "--> [NOUVEAU] ($CLONE_INDEX/$NUM_TO_CLONE) Clonage HTTPS de $path_with_ns vers $target_dir"
        mkdir -p "$(${pkgs.coreutils}/bin/dirname "$target_dir")"

        if ! eval "$GIT_CMD clone \"$http_url\" \"$target_dir\""; then
          echo "Erreur lors du clonage de $path_with_ns"
          if [ -x "${pkgs.libnotify}/bin/notify-send" ]; then
            ${pkgs.libnotify}/bin/notify-send -u critical "GitLab Sync" "Erreur clonage ($CLONE_INDEX/$NUM_TO_CLONE) : $path_with_ns" || true
          fi
        else
          CLONED_SUCCESS=$((CLONED_SUCCESS + 1))
          if [ -x "${pkgs.libnotify}/bin/notify-send" ]; then
            ${pkgs.libnotify}/bin/notify-send -u normal "GitLab Sync" "Téléchargé ($CLONE_INDEX/$NUM_TO_CLONE) : $path_with_ns" || true
          fi
        fi
      done
    fi

    # 2. Mise à jour des dépôts existants
    if [ "$NUM_TO_UPDATE" -gt 0 ]; then
      for item in "''${TO_UPDATE[@]}"; do
        IFS=$'\t' read -r path_with_ns http_url target_dir local_rel_path <<< "$item"
        echo "--> [EXISTANT] Mise à jour HTTPS de $local_rel_path"
        (
          cd "$target_dir"
          # Remote origin en HTTPS via le token
          ${pkgs.git}/bin/git remote set-url origin "$http_url" 2>/dev/null || true
          # Supprimer toute configuration pushurl SSH résiduelle
          ${pkgs.git}/bin/git config --unset-all remote.origin.pushurl 2>/dev/null || true

          if ${pkgs.git}/bin/git remote | grep -q "origin"; then
            eval "$GIT_CMD fetch --all --prune --quiet" || true

            current_branch="$(${pkgs.git}/bin/git branch --show-current 2>/dev/null || true)"
            if [ -n "$current_branch" ]; then
              # Rebase + autostash pour préserver les fichiers modifiés et commits locaux
              if ! eval "$GIT_CMD pull --rebase --autostash --quiet 2>/dev/null"; then
                echo "Attention : conflit sur $local_rel_path. Rebase annulé, modifications locales préservées."
                ${pkgs.git}/bin/git rebase --abort 2>/dev/null || true
                if [ -x "${pkgs.libnotify}/bin/notify-send" ]; then
                  ${pkgs.libnotify}/bin/notify-send -u critical "GitLab Sync" "Conflit sur $local_rel_path : modifications préservées" || true
                fi
              fi
            fi
          fi
        )
      done
    fi

    echo "=== Synchronisation terminée avec succès ==="
    if [ -x "${pkgs.libnotify}/bin/notify-send" ]; then
      if [ "$NUM_TO_CLONE" -gt 0 ]; then
        ${pkgs.libnotify}/bin/notify-send -u normal "GitLab Sync" "Synchronisation terminée : $CLONED_SUCCESS/$NUM_TO_CLONE nouveau(x) favori(s) téléchargé(s), $NUM_TO_UPDATE à jour." || true
      else
        ${pkgs.libnotify}/bin/notify-send -u low "GitLab Sync" "Synchronisation terminée : les $TOTAL_PROJECTS projet(s) favori(s) sont à jour." || true
      fi
    fi
  '';
in {
  # Déclaration du secret agenix
  age.secrets.gitlab-token = {
    file = ../secrets/gitlab-token.age;
    owner = "yannis";
    group = "yannis";
    mode = "0400";
  };

  # Ajout du script aux outils disponibles dans le système
  environment.systemPackages = [
    syncGitlabRepos
  ];

  # Service et timer systemd utilisateur
  home-manager.users.yannis = {
    systemd.user.services.gitlab-sync-repos = {
      Unit = {
        Description = "Synchronisation automatique des dépôts GitLab";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        Type = "oneshot";
        TimeoutStartSec = "300s";
        EnvironmentFile = config.age.secrets.gitlab-token.path;
        Environment = [
          "GITLAB_HOST=git.resel.fr"
          "GIT_PROTOCOL=https"
        ];
        PassEnvironment = [
          "DBUS_SESSION_BUS_ADDRESS"
          "WAYLAND_DISPLAY"
          "DISPLAY"
          "XDG_RUNTIME_DIR"
        ];
        path = with pkgs; [
          git
          glab
          coreutils
          findutils
          iputils
          jq
          libnotify
        ];
        ExecStart = "${syncGitlabRepos}/bin/sync-gitlab-repos";
      };
    };

    systemd.user.timers.gitlab-sync-repos = {
      Unit = {
        Description = "Minuteur pour la synchronisation automatique des dépôts GitLab";
      };
      Timer = {
        OnStartupSec = "2m";
        OnUnitActiveSec = "1h";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
