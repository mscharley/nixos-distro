{
	description = "Definitions for deploying my distribution of NixOS";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";

		flake-parts.url = "github:hercules-ci/flake-parts/main";

		nix-flatpak.url = "github:gmodena/nix-flatpak/main";

		nix-index-database = {
			url = "github:nix-community/nix-index-database/main";
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

		nvf = {
			url = "github:notashelf/nvf/main";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		lanzaboote = {
			url = "github:nix-community/lanzaboote/v1.0.0";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ flake-parts, nvf, ... }: 
		flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
			systems = [ "x86_64-linux" "aarch64-linux" ];

			flake = {
				lib.genSystem = import ./lib/genSystem.nix { inherit inputs; };
				lib.genUser = import ./lib/genUser.nix;
			};

			perSystem = { pkgs, ... }: {
				packages.nvf = (nvf.lib.neovimConfiguration {
					inherit pkgs;
					modules = [ ./packages/nvf.nix ];
				}).neovim;
			};
		});
}
