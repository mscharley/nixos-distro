userDefinitionFile: vars@{ pkgs, lib, ... }: let
	username = baseNameOf userDefinitionFile;
	def = import userDefinitionFile;
	user = def.user;
	home-manager = if (def ? home-manager) then def.home-manager else null;
	modules = if (def ? modules) then def.modules else [];
in {
	imports = modules;

	users.users.${username} = user vars;
	home-manager.users.${username} = lib.mkIf (home-manager != null) home-manager;
}
