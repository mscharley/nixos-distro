{ inputs }:
let
  resolveModules = import ./resolveModules.nix inputs.nixpkgs.lib "nixos";
in
{
  hostname,
  system,
  cpu,
  gpu ? "none",
  formFactor ? "desktop",
  desktop ? if formFactor == "server" then "none" else "kde",
  users ? [ ],
  # https://github.com/NixOS/nixos-hardware?tab=readme-ov-file#list-of-profiles
  hardwareProfile ? null,
  hardware ? [ ],
  extraDesktops ? [ ],
  roles ? [ ],
  services ? [ ],
  modules ? [ ],
  homeManagerModules ? [ ],
  allowUnfreePackages ? [ ],
  overlays ? [ ],
}:
let
  nixpkgs = inputs.nixpkgs;
  defaultHardware =
    let
      hardware = inputs.nixos-hardware.nixosModules;
    in
    if formFactor == "laptop" then
      [
        hardware.common-pc-laptop
        hardware.common-pc-laptop-ssd
      ]
    else
      [
        hardware.common-pc
        hardware.common-pc-ssd
      ];
  nixosHardware =
    if hardwareProfile == null then
      defaultHardware
    else
      [ inputs.nixos-hardware.nixosModules.${hardwareProfile} ];
  pkgs = import nixpkgs {
    inherit system;

    config = {
      rocmSupport = nixpkgs.lib.mkIf (gpu == "amd") true;
      cudaSupport = nixpkgs.lib.mkIf (gpu == "nvidia") true;

      # Global whitelist of specific non-free packages which are acceptable.
      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowUnfreePackages;
    };

    overlays = overlays ++ [
      (import ../overlays/self-packages.nix { self = inputs.self; })
      (import ../overlays/lix.nix)
      # https://github.com/NixOS/nixpkgs/issues/540025
      (final: prev: {
        python314Packages = prev.python314Packages.overrideScope (
          pyFinal: pyPrev: {
            patool = pyPrev.patool.overridePythonAttrs (_old: {
              doCheck = false;
              doInstallCheck = false;
            });
          }
        );
      })
    ];
  };
  specialArgs = {
    inherit desktop cpu gpu;
    platform = "nixos";
    distro-inputs = inputs;
  };
in
(nixpkgs.lib.nixosSystem {
  inherit specialArgs;
  inherit pkgs;
  modules =
    modules
    ++ nixosHardware
    ++ (map (hw: ../modules/nixos/hardware/${hw}.nix) hardware)
    ++ (map (de: ../modules/nixos/desktops/${de}.nix) extraDesktops)
    ++ (resolveModules "roles" roles)
    ++ (resolveModules "services" services)
    ++ (resolveModules "form-factors" [ formFactor ])
    ++ (map (u: u.module) users)
    ++ [
      ../modules/config
      ../modules/nixos/hardware/cpu/${cpu}.nix
      ../modules/nixos/hardware/gpu/${gpu}.nix
      ../modules/nixos/desktops/${desktop}.nix
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      {
        # Set a default hostname based on configuration
        networking.hostName = nixpkgs.lib.mkDefault hostname;

        # Set up home manager
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.backupFileExtension = "backup";
        home-manager.sharedModules = [
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.plasma-manager.homeModules.plasma-manager
        ]
        ++ homeManagerModules;
      }
    ];
})
