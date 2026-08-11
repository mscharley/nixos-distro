{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    socat
    openssl
    bat
  ];
}
