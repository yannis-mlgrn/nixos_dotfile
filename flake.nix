{
  description = "Configuration NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qylock.url = "github:Darkkal44/qylock";
    antigravity-nix.url = "github:jacopone/antigravity-nix";
  };

  outputs = { self, nixpkgs, home-manager, agenix, qylock, antigravity-nix, ... }@inputs: {
    nixosConfigurations.dellYannis = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Transmet inputs aux modules NixOS
      specialArgs = { inherit inputs; };

      modules = [
        qylock.nixosModules.default
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default

        {
          home-manager.extraSpecialArgs = { inherit inputs; };
        }

        ./configuration.nix
      ];
    };
  };
}
