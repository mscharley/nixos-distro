{ ... }:
{
	imports = [ ./bootloader/secureboot.nix ];

	hardware.cpu.intel.updateMicrocode = true;
}
