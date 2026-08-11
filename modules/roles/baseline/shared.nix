{ pkgs, ... }:
{
	nix = {
		package = pkgs.lixPackageSets.stable.lix;
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = false;
		};
	};

	# Enable shells
	programs.zsh.enable = true;
	programs.fish.enable = true;

	programs.direnv = {
		enable = true;
		settings.global.warn_timeout = "0";
	};
}
