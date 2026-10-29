{ pkgs, ... }:
{
  homebrew = {
    brews = [
      "docker-credential-helper"
    ];
    casks = [
      "docker-desktop"
    ];
  };

  environment.systemPackages = with pkgs; [ kubectl ];
}
