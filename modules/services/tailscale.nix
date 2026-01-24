{ pkgs, desktop, lib, ... }:
let
	interface = "tailscale0";
in {
	services.tailscale = {
		enable = true;
		interfaceName = interface;
		openFirewall = true;
	};

	# Trust the tailnet implicitly, it has it's own ACL behaviour
	networking.firewall.trustedInterfaces = [ interface ];

	environment.systemPackages = lib.mkIf (desktop != "none") (with pkgs; [ trayscale ]);
}
