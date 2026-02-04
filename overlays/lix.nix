_final: prev: {
	# https://lix.systems/add-to-config/#advanced-change
	inherit (prev.lixPackageSets.stable)
		nixpkgs-review
		nix-eval-jobs
		nix-fast-build
		colmena;
}
