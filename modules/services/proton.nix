{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		protonplus
	];
}
