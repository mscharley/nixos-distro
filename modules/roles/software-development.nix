{ pkgs, ... }:
{
	imports = [ ./container-host.nix ./vm-host.nix ];

	environment.systemPackages = with pkgs; [
		# CLI tools
		socat
		openssl
		bat

		# GUI tools
		dbeaver-bin
	];
}
