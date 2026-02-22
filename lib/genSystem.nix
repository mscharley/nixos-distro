{ inputs }:
{
	hostname,
	system,
	cpu,
	gpu ? "none",
	formFactor ? "desktop",
	desktop ? if formFactor == "server" then "none" else "kde",
	users ? [],
	# https://github.com/NixOS/nixos-hardware?tab=readme-ov-file#list-of-profiles
	hardwareProfile ? null,
	hardware ? [],
	extraDesktops ? [],
	roles ? [],
	services ? [],
	modules ? [],
	homeManagerModules ? [],
	allowUnfreePackages ? [],
	overlays ? [],
}: let
	nixpkgs = inputs.nixpkgs;
	defaultHardware = let hardware = inputs.nixos-hardware.nixosModules; in
		if formFactor == "laptop"
		then [ hardware.common-pc-laptop hardware.common-pc-laptop-ssd ]
		else [ hardware.common-pc hardware.common-pc-ssd ];
	nixosHardware =
		if hardwareProfile == null then defaultHardware
		else [ inputs.nixos-hardware.nixosModules.${hardwareProfile} ];
	pkgs = import nixpkgs {
		inherit system;

		config = {
			rocmSupport = nixpkgs.lib.mkIf (gpu == "amd") true;
			cudaSupport = nixpkgs.lib.mkIf (gpu == "nvidia") true;

			# Global whitelist of specific non-free packages which are acceptable.
			allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowUnfreePackages;
		};

		overlays = overlays ++ [
			(import ../overlays/self-packages.nix { self = inputs.self; })
			(import ../overlays/lix.nix)
		];
	};
	specialArgs = {
		inherit desktop cpu gpu;
		distro-inputs = inputs;
	};
in (nixpkgs.lib.nixosSystem {
	inherit specialArgs;
	inherit pkgs;
	modules = modules ++ nixosHardware ++
		(map (hw: ../modules/hardware/${hw}.nix) hardware) ++
		(map (de: ../modules/desktops/${de}.nix) extraDesktops) ++
		(map (r: ../modules/roles/${r}.nix) roles) ++
		(map (s: ../modules/services/${s}.nix) services) ++
		(map (u: u.module) users) ++
		[
			../modules/config
			../modules/hardware/cpu/${cpu}.nix
			../modules/hardware/gpu/${gpu}.nix
			../modules/desktops/${desktop}.nix
			../modules/form-factors/${formFactor}.nix
			inputs.disko.nixosModules.disko
			inputs.home-manager.nixosModules.home-manager
			{
				# Set a default hostname based on configuration
				networking.hostName = nixpkgs.lib.mkDefault hostname;

				# Set up home manager
				home-manager.useGlobalPkgs = true;
				home-manager.useUserPackages = true;
				home-manager.extraSpecialArgs = specialArgs;
				home-manager.backupFileExtension = "backup";
				home-manager.sharedModules = [
					inputs.nix-flatpak.homeManagerModules.nix-flatpak
					inputs.plasma-manager.homeModules.plasma-manager
				] ++ homeManagerModules;
			}
		];
})
