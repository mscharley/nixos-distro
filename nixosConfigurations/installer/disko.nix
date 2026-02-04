{ flake-inputs, pkgs, ... }:
{
	disko.enableConfig = false;

	environment.systemPackages = with flake-inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}; [
		disko disko-install
	];
}
