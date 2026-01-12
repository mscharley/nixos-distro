{ lib, pkgs, desktop, ... }:
{
	imports = [
		../services/discord.nix
		../services/steam.nix
		../services/lutris.nix
	];

	environment.systemPackages = lib.mkIf (desktop == "kde") (with pkgs.kdePackages; [
		# https://apps.kde.org/categories/games/

		# The classics...
		kmines kpat kmahjongg

		# Even older classics...
		kblocks kapman kbreakout kreversi
	]);

	# Extra common hardware support
	hardware = {
		steam-hardware.enable = true;
		xpadneo.enable = true;
	};
}
