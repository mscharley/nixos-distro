{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [ sbctl tpm2-tss ];
}
