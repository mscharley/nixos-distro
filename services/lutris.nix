{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		lutris

		# Lutris doesn't generally use the system wine directly, but having one available does ensure dependencies are
		# available
		wineWowPackages.stable
		winetricks
	];
}
