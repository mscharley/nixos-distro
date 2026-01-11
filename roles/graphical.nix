{ lib, pkgs, ... }:
{
	imports = [
		./baseline.nix
		../services/boot-splash.nix
		../services/firefox.nix
		../services/libreoffice.nix
	];

	# Set your time zone.
	time.timeZone = lib.mkOverride 900 "Australia/Melbourne";

	# Select internationalisation properties
	i18n.defaultLocale = lib.mkOverride 900 "en_AU.UTF-8";

	i18n.extraLocaleSettings = lib.mkOverride 900 {
		LC_ADDRESS = "en_AU.UTF-8";
		LC_IDENTIFICATION = "en_AU.UTF-8";
		LC_MEASUREMENT = "en_AU.UTF-8";
		LC_MONETARY = "en_AU.UTF-8";
		LC_NAME = "en_AU.UTF-8";
		LC_NUMERIC = "en_AU.UTF-8";
		LC_PAPER = "en_AU.UTF-8";
		LC_TELEPHONE = "en_AU.UTF-8";
		LC_TIME = "en_AU.UTF-8";
	};

	# Explicitly disable the X11 windowing system
	services.xserver.enable = false;

	# Enable wayland support as necessary
	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
	};

	# Enable CUPS to print documents
	services.printing.enable = true;

	# Enable sound with pipewire
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	services.flatpak.enable = true;
	environment.systemPackages = with pkgs; [
		wayland-utils wl-clipboard
		distrobox
		ffmpeg
		vlc

		qpwgraph

		# Codecs
		openh264 linphonePackages.msopenh264
	];

	fonts = {
		enableDefaultPackages = true;
		packages = with pkgs; [
			# Custom fonts
			noto-fonts
			noto-fonts-lgc-plus
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			noto-fonts-color-emoji

			# Coding fonts
			nerd-fonts.symbols-only
			fira-code
			victor-mono

			# Compatibility
			adwaita-fonts
		];

		fontconfig.defaultFonts = {
			serif = ["Noto Serif" "Noto Color Emoji"];
			sansSerif = ["Noto Sans" "Noto Color Emoji"];
			monospace = ["Fira Code" "Noto Color Emoji"];
			emoji = ["Noto Color Emoji"];
		};
	};
}
