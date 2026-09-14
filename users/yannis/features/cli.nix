{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    terminator
    bluetui
    ripgrep
    unzip
    tailscale

    # Antigravity CLI via Flake input
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli

    # Gazelle TUI via Flake input
    inputs.gazelle.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.shellAliases = {
    agi = "agy";
  };
}
