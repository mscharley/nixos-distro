{ ... }:
{
  homebrew = {
    enable = true;

    # Leave cleanup off until the switch from the imperative Brewfile has been verified —
    # "zap" will uninstall anything not declared here, and some of these casks may still
    # be tracked by MDM.
    onActivation.cleanup = "none";

    taps = [ ];
    brews = [
      "awscli"
    ];
    casks = [
      "alfred"
      "cyberduck"
      "kitty"
      "session-manager-plugin"
    ];
  };
}
