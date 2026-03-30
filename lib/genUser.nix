userDefinitionFile: let
	def = if builtins.typeOf userDefinitionFile == "path" then import userDefinitionFile else userDefinitionFile;
	userName = if def ? "userName" then def.userName else baseNameOf userDefinitionFile;
	icon = if def ? "icon" then def.icon else null;
in {
	inherit userName;

	module = let
		user = def.user;
		home-manager = if (def ? home-manager) then def.home-manager else null;
		modules = if (def ? modules) then def.modules else [];
	in vars@{ pkgs, lib, ... }: {
		imports = modules;

		config = lib.mkMerge [
			{
				users.users.${userName} = user vars;
				home-manager.users.${userName} = lib.mkIf (home-manager != null) home-manager;
			}
			(lib.mkIf (icon != null) {
				# https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10
				systemd.tmpfiles.rules = [
					"f+ /var/lib/AccountsService/users/${userName}  0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/${userName}\\n"
					"L+ /var/lib/AccountsService/icons/${userName}  - - - - ${icon}"
				];
			})
		];
	};
}
