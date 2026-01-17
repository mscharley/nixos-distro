{ inputs, ... }:
{
	imports = [
		inputs.nixos-hardware.nixosModules.common-cpu-intel
		./bootloader/secureboot.nix
	];

	hardware.cpu.intel.updateMicrocode = true;
}
