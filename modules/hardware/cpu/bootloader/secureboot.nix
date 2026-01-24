{ lib, pkgs, distro-inputs, ... }:
{
	imports = [ distro-inputs.lanzaboote.nixosModules.lanzaboote ];

	# Use the systemd-boot EFI boot loader.
	boot.initrd = {
		systemd.enable = true;
	};
	boot.loader = {
		# Lanzaboote currently replaces the systemd-boot module.
		# This setting is usually set to true in configuration.nix
		# generated at installation time. So we force it to false
		# for now.
		systemd-boot.enable = lib.mkForce false;
		efi.canTouchEfiVariables = true;
	};
	security.tpm2.enable = true;

	environment.systemPackages = with pkgs; [ sbctl tpm2-tss ];

	boot.lanzaboote = {
		enable = true;
		pkiBundle = "/var/lib/sbctl";

		autoEnrollKeys = {
			enable = true;
			autoReboot = true;
		};
	};
}
