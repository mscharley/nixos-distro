{ lib, ... }:
{
	imports = [
		../roles/graphical.nix
	];

	powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
	services.fprintd.enable = true;
}
