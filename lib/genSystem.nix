{ inputs }:
{
	hostname,
	system,
	cpu,
	gpu ? "none",
	formFactor ? "desktop",
	desktop ? if formFactor == "server" then "none" else "kde",
	users ? [],
	hardware ? [],
	extraDesktops ? [],
	roles ? [],
	services ? [],
	modules ? [],
}: let
	nixpkgs = inputs.nixpkgs;
	sharedConfig = { gpu ? "none" }: {
		rocmSupport = nixpkgs.lib.mkIf (gpu == "amd") true;
		cudaSupport = nixpkgs.lib.mkIf (gpu == "nvidia") true;

		# Global whitelist of specific non-free packages which are acceptable.
		allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
			"1password" "1password-cli"
			"discord"
			"steam" "steam-unwrapped" "steamcmd"
		];
	};
	pkgs = import inputs.nixpkgs {
		inherit system;

		config = sharedConfig { inherit gpu; };

		overlays = [
			# https://lix.systems/add-to-config/#advanced-change
			(_final: prev: {
				inherit (prev.lixPackageSets.stable)
					nixpkgs-review
					nix-eval-jobs
					nix-fast-build
					colmena;
			})
			(_final: prev: {
				distro = inputs.self.packages.${system};
			})
		];
	};
	specialArgs = {
		inherit desktop;
		flake-inputs = inputs;
	};
in (nixpkgs.lib.nixosSystem {
	inherit specialArgs;
	inherit pkgs;
	modules = (map (hw: ../hardware/${hw}.nix) hardware) ++
		(map (de: ../desktops/${de}.nix) extraDesktops) ++
		(map (r: ../roles/${r}.nix) roles) ++
		(map (s: ../services/${s}.nix) services) ++
		modules ++ users ++ [
			../hardware/cpu.${cpu}.nix
			../hardware/gpu.${gpu}.nix
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
				];
			}
		];
})
