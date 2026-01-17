{ inputs, ... }:
{
	imports = [
		inputs.nixos-hardware.nixosModules.common-gpu-nvidia
	];

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};
}
