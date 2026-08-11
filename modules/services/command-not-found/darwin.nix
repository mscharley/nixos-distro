{ distro-inputs, ... }:
{
  # Import the upstream module
  imports = [
    distro-inputs.nix-index-database.darwinModules.nix-index
    ./shared.nix
  ];
}
