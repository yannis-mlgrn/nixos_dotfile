{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    kitty
    bluetui
    ripgrep
    unzip
    tailscale
    fastfetch

    # Antigravity CLI via Flake input
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli

    # Gazelle TUI via Flake input
    inputs.gazelle.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.shellAliases = {
    agi = "agy";
    neofetch = "fastfetch";
  };
}
