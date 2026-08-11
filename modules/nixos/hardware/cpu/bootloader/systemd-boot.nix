{ ... }:
{
	# Use the systemd-boot EFI boot loader.
	boot.initrd = {
		systemd.enable = true;
	};
	boot.loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
	};
}
