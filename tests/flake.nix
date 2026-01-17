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
			hardwareProfile = "framework-12th-gen-intel";
			cpu = "intel";
			roles = [ "software-development" ];
			services = commonServices ++ [ "discord" ];
			modules = [ ./dummy-hardware.nix ];
		};
		nixosConfigurations.desktop = distro.lib.genSystem {
			hostname = "desktop";
			system = "x86_64-linux";
			formFactor = "desktop";
			cpu = "amd";
			roles = [ "software-development" "gaming" ];
			services = commonServices ++ [ "discord" ];
			modules = [ ./dummy-hardware.nix ];
		};
		nixosConfigurations.arm = distro.lib.genSystem {
			hostname = "arm";
			system = "aarch64-linux";
			formFactor = "server";
			cpu = "arm";
			roles = [ "software-development" ];
			modules = [ ./dummy-hardware.nix ];
		};
	};
}

