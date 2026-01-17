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
	allowUnfreePackages ? [
		"1password" "1password-cli"
		"discord"
		"steam" "steam-unwrapped" "steamcmd"
	],
}: let
	nixpkgs = inputs.nixpkgs;
	defaultHardware = let hardware = inputs.nixos-hardware.nixosModules; in
		if formFactor == "laptop"
		then [ hardware.common-pc-laptop hardware.common-pc-laptop-ssd ]
		else [ hardware.common-pc hardware.common-pc-ssd ];
	nixosHardware =
		if hardwareProfile == null then defaultHardware
		else [ inputs.nixos-hardware.nixosModules.${hardwareProfile} ];
	pkgs = import inputs.nixpkgs {
		inherit system;

		config = {
			rocmSupport = nixpkgs.lib.mkIf (gpu == "amd") true;
			cudaSupport = nixpkgs.lib.mkIf (gpu == "nvidia") true;

			# Global whitelist of specific non-free packages which are acceptable.
			allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowUnfreePackages;
		};

		overlays = [
			# Include our packages in pkgs under the distro namespace
			(_final: prev: {
				distro = inputs.self.packages.${system};
			})
			# https://lix.systems/add-to-config/#advanced-change
			(_final: prev: {
				inherit (prev.lixPackageSets.stable)
					nixpkgs-review
					nix-eval-jobs
					nix-fast-build
					colmena;
			})
		];
	};
	specialArgs = {
		inherit desktop cpu gpu;
		distro-inputs = inputs;
	};
in (nixpkgs.lib.nixosSystem {
	inherit specialArgs;
	inherit pkgs;
	modules = (map (hw: ../hardware/${hw}.nix) hardware) ++
		(map (de: ../desktops/${de}.nix) extraDesktops) ++
		(map (r: ../roles/${r}.nix) roles) ++
		(map (s: ../services/${s}.nix) services) ++
		modules ++ (map (u: u.module) users) ++ nixosHardware ++ [
			../hardware/cpu/${cpu}.nix
			../hardware/gpu/${gpu}.nix
			../desktops/${desktop}.nix
			../form-factors/${formFactor}.nix
			inputs.home-manager.nixosModules.home-manager
			{
				# Set a default hostname based on configuration
				networking.hostName = nixpkgs.lib.mkDefault hostname;

				# Set up home manager
				home-manager.useGlobalPkgs = false;
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
