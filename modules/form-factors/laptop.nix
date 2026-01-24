{ lib, ... }:
{
	imports = [
		../roles/graphical.nix
		../hardware/fprintd.nix
	];

	powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
