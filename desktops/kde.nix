{ pkgs, desktop, ... }:
{
	imports = [
		../roles/graphical.nix
	] ++ (if (desktop == "kde") then [ ../services/sddm.nix ] else []);

	# Enable the KDE Plasma Desktop Environment
	services.desktopManager.plasma6.enable = true;

	# Disable some of the optional packages
	environment.plasma6.excludePackages = with pkgs; [
		# Disable X11 session
		kdePackages.kwin-x11

		# Don't include konsole in favour of kitty
		kdePackages.konsole
	];

	# Enable fcitx5 + mozc as a Japanese IME
	i18n.inputMethod = {
		enable = true;
		type = "fcitx5";
		fcitx5 = {
			addons = with pkgs; [ fcitx5-mozc ];
		};
	};

	# Addon some extra niceties
	environment.systemPackages = with pkgs; [
		# Desirable for updating flatpaks and fwupd
		kdePackages.discover

		# Desktop apps
		kdePackages.kate
		kdePackages.kcalc kdePackages.kcharselect kdePackages.kcolorchooser
		# kdePackages.kamoso
		kdiff3

		# System admin tools
		kdePackages.flatpak-kcm kdePackages.sddm-kcm
		kdePackages.ksystemlog kdePackages.isoimagewriter

		# Gnome compatibility
		adwaita-icon-theme
	];
	programs.kdeconnect.enable = true;
}
