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
      inputs.home-manager.follows = "home-manager";
    };

    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    raktools = {
      url = "git+https://git.resel.fr/ymalgorn1/projects/raktools.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    qylock,
    antigravity-nix,
    ...
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.dellYannis = nixpkgs.lib.nixosSystem {
      # Transmet inputs aux modules NixOS
      specialArgs = {inherit inputs;};

      modules = [
        qylock.nixosModules.default
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default

        {
          home-manager.extraSpecialArgs = {inherit inputs;};
        }

        ./hosts/dellYannis
      ];
    };

    devShells.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          pkg-config
        ];
        buildInputs = with pkgs; [
          openssl
        ];
      };
  };
}
