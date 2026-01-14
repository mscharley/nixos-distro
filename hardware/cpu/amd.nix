{ ... }:
{
	imports = [ ./bootloader/secureboot.nix ];

	hardware.cpu.amd.updateMicrocode = true;
}
