userDefinitionFile: let
	userName = baseNameOf userDefinitionFile;
	def = import userDefinitionFile;
in {
	inherit userName;

	module = let
		user = def.user;
		home-manager = if (def ? home-manager) then def.home-manager else null;
		modules = if (def ? modules) then def.modules else [];
	in vars@{ pkgs, lib, ... }: {
		imports = modules;

		users.users.${userName} = user vars;
		home-manager.users.${userName} = lib.mkIf (home-manager != null) home-manager;
	};
}
