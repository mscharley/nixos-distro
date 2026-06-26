{
  description = "Definitions for deploying my distribution of NixOS";

  inputs = {
    # Official dependencies
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Community dependencies
    nix-index-database = {
      url = "github:nix-community/nix-index-database/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Third-party extensions
    flake-parts.url = "github:hercules-ci/flake-parts/main";

    nix-flatpak.url = "github:gmodena/nix-flatpak/main";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        flake =
          { ... }:
          {
            lib.genSystem = import ./lib/genSystem.nix { inherit inputs; };
            lib.genUser = import ./lib/genUser.nix;

            nixosConfigurations.installer = import ./nixosConfigurations/installer { inherit inputs; };
          };

        perSystem =
          { ... }:
          {
          };
      }
    );
}
