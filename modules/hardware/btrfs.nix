{ ... }:
{
	imports = [
		../services/snapper.nix
	];
	services.btrfs.autoScrub.enable = true;
}
