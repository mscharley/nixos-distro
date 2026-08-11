{ pkgs, ...}:
{
	imports = [
		../proton/nixos.nix
	];

	hardware.steam-hardware.enable = true;

	programs.steam = {
		enable = true;
		protontricks.enable = true;

		localNetworkGameTransfers.openFirewall = true;
		remotePlay.openFirewall = true;
	};

	environment.systemPackages = with pkgs; [
		steamcmd
		gamescope
		mangohud mangojuice
	];
}
