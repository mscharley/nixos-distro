{
	description = "Testing configurations to test building of the distro";

	inputs = {
		distro.url = "path:../";
	};

	outputs = { distro, ... }: let
		commonServices = [ "tailscale" "1password" ];
	in {
		nixosConfigurations.laptop = distro.lib.genSystem {
			hostname = "laptop";
			system = "x86_64-linux";
			formFactor = "laptop";
			cpu = "intel";
			roles = [ "software-development" ];
			services = commonServices ++ [ "discord" ];
		};
		nixosConfigurations.desktop = distro.lib.genSystem {
			hostname = "desktop";
			system = "x86_64-linux";
			formFactor = "desktop";
			cpu = "amd";
			extraDesktops = [ "niri" ];
			roles = [ "software-development" "gaming" ];
			services = commonServices ++ [ "discord" ];
			modules = [ ./dummy-hardware.nix ];
		};
	};
}

