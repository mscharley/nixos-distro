{ pkgs, ... }:
{
  virtualisation = {
    podman.enable = true;
    podman.extraPackages = with pkgs; [
      podman-compose
    ];
  };

  environment.systemPackages = with pkgs; [ kubectl ];
}
