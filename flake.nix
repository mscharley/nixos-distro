{
	description = "Definitions for deploying my distribution of NixOS";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		nix-flatpak.url = "github:gmodena/nix-flatpak/main";

		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		plasma-manager = {
			url = "github:nix-community/plasma-manager/trunk";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};

		nvf = {
			url = "github:notashelf/nvf";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ nixpkgs, nvf, ... }: {
		lib.genSystem = import ./lib/genSystem.nix { inherit inputs; };

		packages.x86_64-linux.nvf = (nvf.lib.neovimConfiguration {
			pkgs = nixpkgs.legacyPackages.x86_64-linux;
			modules = [ ./packages/nvf.nix ];
		}).neovim;
		packages.aarch64-linux.nvf = (nvf.lib.neovimConfiguration {
			pkgs = nixpkgs.legacyPackages.x86_64-linux;
			modules = [ ./packages/nvf.nix ];
		}).neovim;
	};
}
