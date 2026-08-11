{ pkgs, ... }:
{
  homebrew = {
    brews = [
      "docker-credential-helper"
    ];
    casks = [
      "docker"
      "docker-desktop"
    ];
  };

  environment.systemPackages = with pkgs; [ kubectl ];
}
