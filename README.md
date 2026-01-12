# NixOS distribution flake

Name pending. This is mostly a proof of concept for distribution of something akin to a branched distribution of NixOS based on this flake for managing the changes over base NixOS.

## Installation

I'm currently running this as a daily driver on multiple real systems, however for now installation instructions are beyond the scope of this document. Sufficed to say, you should be able to get going as if you were installing NixOS via a flake normally however. You will still want to use `nixos-generate-config` to generate hardware-specific configuration for your system. My current `flake.nix` for my main system looks like the following:

```nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{
	description = "";

	inputs = {
		distro.url = "github:mscharley/nixos-distro/unstable";
	};

	outputs = { distro, self, ... }: let
		commonModules = [ ./shared/home-certificate-authority.nix ];
		commonServices = [ "tailscale" "1password" ];
	in {
		users = {
			matthew = distro.lib.genUser "matthew" (import ./users/matthew);
		};

		nixosConfigurations.fw13 = distro.lib.genSystem {
			hostname = "fw13";
			system = "x86_64-linux";
			formFactor = "laptop";
			cpu = "intel";
			hardware = [ "bluetooth" ];
			roles = [ "software-development" ];
			services = commonServices ++ [ "discord" ];
			users = [ self.users.matthew ];
			modules = commonModules ++ [ ./hosts/fw13/configuration.nix ];
		};
		nixosConfigurations.desktop = distro.lib.genSystem {
			hostname = "desktop";
			system = "x86_64-linux";
			formFactor = "desktop";
			cpu = "amd";
			gpu = "amd";
			hardware = [ "bluetooth" "logitech" ];
			extraDesktops = [ "niri" ];
			roles = [ "software-development" "gaming" ];
			services = commonServices ++ [ ];
			users = [ self.users.matthew ];
			modules = commonModules ++ [ ./hosts/desktop/configuration.nix ];
		};
	};
}
```
