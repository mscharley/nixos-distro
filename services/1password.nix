{ userNames, ... }:
{
	programs._1password.enable = true;
	programs._1password-gui = {
		enable = true;
		polkitPolicyOwners = userNames;
	};

	# Required for system authentication support
	security.polkit.enable = true;
}
