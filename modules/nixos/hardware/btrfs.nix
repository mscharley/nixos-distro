{ ... }:
{
	imports = [
		../../services/snapper/nixos.nix
	];
	services.btrfs.autoScrub.enable = true;
}
