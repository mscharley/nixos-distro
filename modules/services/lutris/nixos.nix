{ pkgs, ... }:
{
	imports = [
		../proton/nixos.nix
		# Lutris doesn't generally use the system wine directly, but having one available is recommended to ensure
		# dependencies are available
		../wine/nixos.nix
	];

	environment.systemPackages = with pkgs; [
		lutris gamescope
	];
}
