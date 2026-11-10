{ pkgs, lib, ... }:
{
  programs.appimage = {
    enable = lib.mkDefault true;
    # Register binfmt handlers so AppImages can be executed directly
    binfmt = lib.mkDefault true;
  };

  # Gear Lever handles "installing" AppImages: moves them to a managed folder, creates desktop
  # entries and manages updates.
  environment.systemPackages = [ pkgs.gearlever ];

  # Default Gear Lever's managed folder to XDG_BIN_HOME instead of ~/AppImages. Gear Lever only
  # expands a leading `~`, not environment variables. This is a system dconf default; users can
  # still change it in Gear Lever's preferences.
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."it/mijorus/gearlever".appimages-default-folder = "~/.local/bin";
      }
    ];
  };
}
