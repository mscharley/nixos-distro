{
  config,
  lib,
  pkgs,
  distro-inputs,
  ...
}:
let
  cfg = config.distro.secureboot.measuredBoot;
in
{
  imports = [ distro-inputs.lanzaboote.nixosModules.lanzaboote ];

  options.distro.secureboot.measuredBoot = {
    enable = lib.mkEnableOption "TPM2 Measured Boot via lanzaboote and systemd-pcrlock";
    pcrs = lib.mkOption {
      description = "PCRs to lock via systemd-pcrlock.";
      type = lib.types.listOf lib.types.int;
      default = [
        0
        4
        7
      ];
    };
  };

  config = lib.mkMerge [
    {
      boot.loader = {
        # Lanzaboote currently replaces the systemd-boot module.
        # This setting is usually set to true in configuration.nix
        # generated at installation time. So we force it to false
        # for now.
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = true;
      };
      security.tpm2.enable = true;

      environment.systemPackages = with pkgs; [
        sbctl
        tpm2-tss
      ];

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";

        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
      };
    }
    (lib.mkIf cfg.enable {
      boot.lanzaboote = {
        # systemd-pcrlock can't build a policy for more than 4 generations,
        # and lanzaboote asserts this.
        configurationLimit = lib.mkDefault 4;
        measuredBoot = {
          enable = true;
          inherit (cfg) pcrs;
        };
      };
    })
  ];
}
