{ inputs, self }:
let
	system = "x86_64-linux";
in inputs.nixpkgs.lib.nixosSystem {
	specialArgs = { flake-inputs = inputs; desktop = "none"; };
	modules = [
		"${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"
		inputs.disko.nixosModules.disko
		{
			nixpkgs.hostPlatform = system;
			nixpkgs.overlays = [
				(import ../../overlays/self-packages.nix { inherit self; })
				(import ../../overlays/lix.nix)
			];
		}
		./config.nix
	];
}
