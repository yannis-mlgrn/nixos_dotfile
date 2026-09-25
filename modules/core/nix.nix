{pkgs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Activation de nh (Nix Helper) avec nvd intégré
  programs.nh = {
    enable = true;
    flake = "/home/yannis/Documents/gitlab/ymalgorn/dotfiles/nixos-laptop";
  };

  environment.systemPackages = with pkgs; [
    nvd
  ];

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };
}
