{ config, pkgs, ... }:
{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = false;
    };
  };

  environment.systemPackages = with pkgs; [
    config.distro.editor
    nano
    git
    git-lfs
    curl
    wget
    screen
    file
    tree
    xz
    zip
    unzip
    fastfetch
    hyfetch
  ];

  # Enable shells
  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.direnv = {
    enable = true;
    settings.global.warn_timeout = "0";
  };
}
