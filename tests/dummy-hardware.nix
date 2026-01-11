{ ... }:
{
	fileSystems."/" = {
		device = "/dev/null";
		fsType = "btrfs";
	};
	system.stateVersion = "26.05";
}
