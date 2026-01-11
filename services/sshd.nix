{ ... }:
{
	# Enable the OpenSSH daemon
	services.openssh = {
		enable = true;
		authorizedKeysInHomedir = true;
		startWhenNeeded = true;
		settings = {
			PermitRootLogin = "no";
			KbdInteractiveAuthentication = false;
			PasswordAuthentication = false;
			X11Forwarding = false;
		};
		openFirewall = true;
	};
}
