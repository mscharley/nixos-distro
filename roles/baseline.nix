{ lib, pkgs, flake-pkgs, ... }:
let
	amdgpu = pkgs.config.rocmSupport;
in {
	imports = [
		# Other base services
		../hardware/btrfs.nix
		../services/sshd.nix
		../services/command-not-found.nix
	];

	config = lib.mkMerge [
		{
			nix = {
				package = pkgs.lixPackageSets.stable.lix;
				settings = {
					experimental-features = [ "nix-command" "flakes" ];
					auto-optimise-store = false;
				};
			};

			time.timeZone = lib.mkDefault "Etc/UTC";
			i18n = {
				defaultLocale = lib.mkDefault "en_US.UTF-8";
				defaultCharset = lib.mkDefault "UTF-8";
				extraLocales = lib.mkDefault [
					"en_US.UTF-8/UTF-8"
					"en_GB.UTF-8/UTF-8"
					"en_AU.UTF-8/UTF-8"
					"ja_JP.UTF-8/UTF-8"
				];
			};

			# Use the nh helper for interacting with rebuilds
			programs.nh = {
				enable = true;
				clean.enable = true;
				clean.extraArgs = "--keep-since 7d --keep 5";
			};

			# Use latest kernel by default
			boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

			# Use the systemd-boot EFI boot loader.
			boot.loader.systemd-boot.enable = true;
			boot.loader.efi.canTouchEfiVariables = true;

			# Enable networking via networkmanager
			networking.networkmanager.enable = true;

			# Enable shells
			programs.zsh.enable = true;
			programs.fish.enable = true;

			# List packages installed in system profile.
			environment.systemPackages = with pkgs; [
				# Hardware tools
				pciutils usbutils

				# Networking tools
				dig whois
				curl wget
				screen

				# Software
				vim flake-pkgs.nvf
				git git-lfs gcc
				fastfetch hyfetch
				tree
				psmisc file lynx
				zip unzip xz
				zbar
			];
			programs.direnv.enable = true;
			programs.usbtop.enable = true;

			security = {
				sudo.enable = false;
				sudo-rs.enable = true;
			};
			services.fwupd.enable = true;

			# Open ports in the firewall.
			# networking.firewall.allowedTCPPorts = [ ... ];
			# networking.firewall.allowedUDPPorts = [ ... ];
			# Or disable the firewall altogether.
			# networking.firewall.enable = false;

			# Copy the NixOS configuration file and link it from the resulting system
			# (/run/current-system/configuration.nix). This is useless and unavailable
			# when using flakes.
			system.copySystemConfiguration = false;
		}
		(lib.mkIf (!amdgpu) { environment.systemPackages = [ pkgs.btop ]; })
		(lib.mkIf amdgpu { environment.systemPackages = [ pkgs.btop-rocm ]; })
	];
}
