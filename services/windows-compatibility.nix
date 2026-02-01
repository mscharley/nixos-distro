{ pkgs, ... }:
{
	imports = [
		./wine.nix
	];

	environment.systemPackages = with pkgs; [
		bottles
	];
}
