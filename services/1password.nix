{ config, ... }:
{
	programs._1password.enable = true;
	programs._1password-gui = {
		enable = true;
		polkitPolicyOwners = builtins.attrNames config.users.users;
	};

	# Required for system authentication support
	security.polkit.enable = true;
}
