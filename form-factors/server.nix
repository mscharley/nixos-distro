{ lib, pkgs, ... }:
{
	imports = [
		../roles/baseline.nix
	];

	# Use LTS kernel by default
	boot.kernelPackages = lib.mkOverride 900 pkgs.linuxPackages;

	# Set your time zone.
	time.timeZone = "Etc/UTC";

	# Select internationalisation properties
	i18n.defaultLocale = "en_US.UTF-8";
}
