{ lib, config, pkgs, ... }:
{
	imports = [
		../services/discord.nix
		../services/steam.nix
		../services/lutris.nix
	];

	environment.systemPackages = lib.mkIf config.services.desktopManager.plasma6.enable (with pkgs.kdePackages; [
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
