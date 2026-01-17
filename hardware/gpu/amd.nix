{ distro-inputs, ... }:
{
	imports = [
		distro-inputs.nixos-hardware.nixosModules.common-gpu-amd
	];

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};
	hardware.amdgpu = {
		opencl.enable = true;
	};
}
