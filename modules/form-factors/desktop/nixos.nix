{ lib, ... }:
{
	imports = [
		../../roles/graphical/nixos.nix
	];

	powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
