{ pkgs, ... }:
{
  imports = [
    ../container-host/nixos.nix
    ../vm-host/nixos.nix
  ];

  environment.systemPackages = with pkgs; [
    # CLI tools
    socat
    openssl
    bat

    # GUI tools
    dbeaver-bin
  ];
}
