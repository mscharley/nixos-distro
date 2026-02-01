{ pkgs, ... }:
{
	imports = [
		./proton.nix
		# Lutris doesn't generally use the system wine directly, but having one available is recommended to ensure
		# dependencies are available
		./wine.nix
	];

	environment.systemPackages = with pkgs; [
		lutris
	];
}
