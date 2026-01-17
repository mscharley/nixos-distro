{ distro-inputs, ... }:
{
	imports = [
		distro-inputs.nixos-hardware.nixosModules.common-gpu-intel
	];

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};
}
