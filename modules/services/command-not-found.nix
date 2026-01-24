{ distro-inputs, ... }:
{
	# Import the upstream module
	imports = [ distro-inputs.nix-index-database.nixosModules.nix-index ];

	# A lot of this is set automatically by nix-index-database, but we're explicit about forcing these options here.
	programs.command-not-found.enable = false;
	programs.nix-index.enable = true;
	programs.nix-index-database.comma.enable = true;
}
