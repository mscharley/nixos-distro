{ pkgs, ... }:
{
	virtualisation = {
		podman.enable = true;
		podman.extraPackages = with pkgs; [
			podman-compose
		];
		libvirtd.enable = true;
		spiceUSBRedirection.enable = true;
	};
	programs.virt-manager.enable = true;
	environment.systemPackages = with pkgs; [
		# CLI tools
		kubectl
		socat
		openssl

		# GUI tools
		dbeaver-bin
	];
}
