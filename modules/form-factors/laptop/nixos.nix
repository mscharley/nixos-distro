{ lib, ... }:
{
	imports = [
		../../roles/graphical/nixos.nix
		../../nixos/hardware/fprintd.nix
	];

	powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
