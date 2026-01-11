{ lib, ... }:
{
	imports = [
		../roles/graphical.nix
	];

	powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
