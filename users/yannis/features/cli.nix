{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    terminator
    impala
    bluetui
    ripgrep
    unzip
    tailscale

    # Antigravity CLI via Flake input
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
  ];

  home.shellAliases = {
    agi = "agy";
  };
}
