{ lib, pkgs, ... }:
{
	imports = [
		../../modules/services/sshd/nixos.nix
		../../modules/services/tailscale/nixos.nix
		./disko.nix
		./secure-boot.nix
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
