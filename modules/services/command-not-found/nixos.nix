{ distro-inputs, ... }:
{
  # Import the upstream module
  imports = [
    distro-inputs.nix-index-database.nixosModules.nix-index
    ./shared.nix
  ];

  programs.command-not-found.enable = false;
}
