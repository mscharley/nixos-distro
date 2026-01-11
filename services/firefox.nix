{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		firefoxpwa
	];

	programs.firefox = {
		enable = true;
		package = pkgs.firefox;
		nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
	};

}
