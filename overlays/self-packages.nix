{ self }: _final: prev: {
	# Include our packages in pkgs under the distro namespace
	distro = self.packages.${prev.stdenv.hostPlatform.system};
}
