{ inputs }:
let
  resolveModules = import ./resolveModules.nix inputs.nixpkgs.lib "darwin";
in
{
  username,
  system ? "aarch64-darwin",
  # Unlike genSystem, there's no default here: little may be worth switching on for a
  # laptop/desktop distinction under MDM, so a Mac opts in explicitly if it wants one.
  formFactor ? null,
  users ? [ ],
  roles ? [ ],
  services ? [ ],
  modules ? [ ],
  homeManagerModules ? [ ],
  allowUnfreePackages ? [ ],
  overlays ? [ ],
}:
let
  nixpkgs = inputs.nixpkgs;
  pkgs = import nixpkgs {
    inherit system;

    config = {
      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowUnfreePackages;
    };

    overlays = overlays ++ [
      (import ../overlays/self-packages.nix { self = inputs.self; })
      (import ../overlays/lix.nix)
    ];
  };
  specialArgs = {
    # Consumer modules (e.g. dotfiles' homeModules.home) branch on `desktop`; darwin has no
    # equivalent concept, so it's always "none" here.
    desktop = "none";
    platform = "darwin";
    distro-inputs = inputs;
  };
in
(inputs.nix-darwin.lib.darwinSystem {
  inherit specialArgs;
  inherit pkgs;
  modules =
    modules
    # The baseline (Lix, fonts, homebrew shape) applies unconditionally, same as it does on
    # NixOS via every form factor's chain through roles/graphical.
    ++ (resolveModules "roles" [ "baseline" ])
    ++ (resolveModules "roles" roles)
    ++ (resolveModules "services" services)
    ++ (resolveModules "form-factors" (nixpkgs.lib.optional (formFactor != null) formFactor))
    ++ (map (u: u.module) users)
    ++ [
      ../modules/config
      ../modules/darwin/homebrew.nix
      inputs.home-manager.darwinModules.home-manager
      {
        # The MDM-managed account is the primary user; homebrew and system.defaults need
        # this to know who they're acting on behalf of.
        system.primaryUser = username;

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.backupFileExtension = "backup";
        # No nix-flatpak / plasma-manager here — both are Linux-only.
        home-manager.sharedModules = homeManagerModules;
      }
    ];
})
