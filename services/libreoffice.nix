{ pkgs, lib, config, ... }:
{
	environment.systemPackages = lib.mkMerge [
		(with pkgs; [
			hunspell
			hunspellDicts.en-us-large
			hunspellDicts.en-gb-large
			hunspellDicts.en-au-large
		])
		(lib.mkIf config.services.desktopManager.plasma6.enable (with pkgs; [ libreoffice-qt-fresh ]))
		(lib.mkIf (!config.services.desktopManager.plasma6.enable) (with pkgs; [ libreoffice-fresh ]))
	];
}
