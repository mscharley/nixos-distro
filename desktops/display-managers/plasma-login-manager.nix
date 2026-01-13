{ pkgs, ... }:
{
	# TODO: Plasma login manager isn't supported upstream in NixOS yet. Use SDDM for now until then.
	environment.systemPackages = with pkgs; [
		kdePackages.sddm-kcm
	];

	services.displayManager.sddm = {
		enable = true;
		wayland.enable = true;
	};
}
