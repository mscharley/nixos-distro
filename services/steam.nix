{ pkgs, ...}:
{
	imports = [
		./proton.nix
	];

	hardware.steam-hardware.enable = true;

	programs.steam = {
		enable = true;
		protontricks.enable = true;

		localNetworkGameTransfers.openFirewall = true;
		remotePlay.openFirewall = true;

		extraPackages = with pkgs; [
			gamescope
		];
	};

	environment.systemPackages = with pkgs; [
		steamcmd
		mangohud mangojuice
	];
}
