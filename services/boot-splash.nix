{ pkgs, config, ... }:
{
	# Enable Plymouth for pretty boot splash.
	boot = {
		plymouth = {
			enable = true;
			theme = "breeze";
			themePackages = with pkgs; [
				(kdePackages.breeze-plymouth.override {
					logoFile = "${nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake.png";
					logoName = "nixos";
					osName = "NixOS";
					osVersion = config.system.nixos.release;
				})
			];
		};

		consoleLogLevel = 3;
		initrd.verbose = false;
		kernelParams = [
			"quiet"
			"splash"
			"boot.shell_on_fail"
			"udev.log_priority=3"
			"rd.systemd.show_status=auto"
			"plymouth.use-simpledrm"
		];

		# Hide the OS choice for bootloaders.
		# It's still possible to open the bootloader list by pressing any key, it will just not appear on screen unless
		# a key is pressed
		# loader.timeout = 0;
	};
}
