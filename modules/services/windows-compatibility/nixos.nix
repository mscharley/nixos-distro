{ pkgs, ... }:
{
	imports = [
		../wine/nixos.nix
	];

	environment.systemPackages = with pkgs; [
		bottles
	];
}
