{ pkgs, lib, desktop, ... }:
{
	environment.systemPackages = lib.mkMerge [
		(with pkgs; [
			hunspell
			hunspellDicts.en-us-large
			hunspellDicts.en-gb-large
			hunspellDicts.en-au-large
		])
		(lib.mkIf (desktop == "kde") (with pkgs; [ libreoffice-qt-fresh ]))
		(lib.mkIf (desktop != "kde") (with pkgs; [ libreoffice-fresh ]))
	];
}
