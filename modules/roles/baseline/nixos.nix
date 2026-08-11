{
  lib,
  pkgs,
  gpu,
  ...
}:
let
  amdgpu = gpu == "amd";
in
{
  imports = [
    # Other base services
    ../../nixos/hardware/btrfs.nix
    ../../services/sshd/nixos.nix
    ../../services/command-not-found/nixos.nix
  ];

  config = lib.mkMerge [
    {
      time.timeZone = lib.mkDefault "Etc/UTC";

      i18n = {
        defaultLocale = lib.mkDefault "en_US.UTF-8";
        defaultCharset = lib.mkDefault "UTF-8";
        extraLocales = lib.mkDefault [ "en_US.UTF-8/UTF-8" ];
      };

      # Use the nh helper for interacting with rebuilds
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 7d --keep 5";
      };

      # Use latest kernel by default
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      hardware.enableRedistributableFirmware = true;

      # Enable networking via networkmanager
      networking.networkmanager.enable = true;

      # List packages installed in system profile.
      environment.systemPackages = with pkgs; [
        # Hardware tools
        pciutils
        usbutils

        # Networking tools
        dig
        whois

        # Software
        gcc
        psmisc
        lynx
        zbar
      ];
      programs.usbtop.enable = true;
      programs.iotop.enable = true;

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
