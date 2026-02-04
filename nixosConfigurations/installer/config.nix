{ lib, pkgs, ... }:
{
	imports = [
		../../modules/services/sshd.nix
		../../modules/services/tailscale.nix
		./disko.nix
	];

	time.timeZone = lib.mkDefault "Etc/UTC";
	boot.supportedFilesystems.zfs = lib.mkForce false;

	nix = {
		package = pkgs.lixPackageSets.stable.lix;
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = false;
		};
	};
	programs.nh = {
		enable = true;
	};
	installer.cloneConfig = false;
}
