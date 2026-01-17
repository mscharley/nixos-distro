{ distro-inputs, ... }:
{
	imports = [
		distro-inputs.nixos-hardware.nixosModules.common-cpu-amd
		./bootloader/secureboot.nix
	];

	hardware.cpu.amd.updateMicrocode = true;
}
