{ distro-inputs, ... }:
{
	imports = [
		distro-inputs.nixos-hardware.nixosModules.common-gpu-nvidia
	];

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};
}
