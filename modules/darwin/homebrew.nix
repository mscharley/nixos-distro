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
			"docker-credential-helper"
		];
		casks = [
			"alfred"
			"cyberduck"
			"docker-desktop"
			"kitty"
			"session-manager-plugin"
		];
	};
}
