{ pkgs, lib, ... }: {
	programs.nix-ld.enable = lib.mkDefault true;
	programs.nix-ld.libraries = with pkgs; [
		# Add any custom libraries needed here
	];
}
