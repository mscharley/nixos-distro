{ pkgs, desktop, ... }:
{
	imports = [
		../../roles/graphical/nixos.nix
	] ++ (if (desktop == "niri") then [ ./display-managers/sddm.nix ] else []);

	programs.niri.enable = true;

	environment.systemPackages = with pkgs; [
		fuzzel swaylock waybar xwayland-satellite
	];
}
