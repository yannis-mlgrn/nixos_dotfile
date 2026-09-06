{...}: {
  home.stateVersion = "25.11";

  imports = [
    ./features/cli.nix
    ./features/desktop.nix
    ./features/dev.nix
    ./features/git.nix
    ./features/resel.nix
    # ./features/internship.nix
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
