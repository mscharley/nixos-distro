{ inputs, ... }:
{
	imports = [
		inputs.nixos-hardware.nixosModules.common-cpu-amd
		./bootloader/secureboot.nix
	];

	hardware.cpu.amd.updateMicrocode = true;
}
