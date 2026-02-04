{ lib, pkgs, ... }:
{
	options = {
		distro = {
			editor = lib.mkOption {
				description = "Package to install as the default editor.";
				type = lib.types.package;
				default = pkgs.vim;
			};
		};
	};
}
