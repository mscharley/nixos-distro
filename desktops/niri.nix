{ pkgs, desktop, ... }:
{
	imports = [
		../roles/graphical.nix
	] ++ (if (desktop == "niri") then [ ../services/sddm.nix ] else []);

	programs.niri.enable = true;

	environment.systemPackages = with pkgs; [
		fuzzel swaylock waybar xwayland-satellite
	];
}
