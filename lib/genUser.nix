userDefinitionFile: let
	def = if builtins.typeOf userDefinitionFile == "path" then import userDefinitionFile else userDefinitionFile;
	userName = if def ? "userName" then def.userName else baseNameOf userDefinitionFile;
	icon = if def ? "icon" then def.icon else null;
	# `user` is optional: omit it for a home-manager-only account, where the system-level
	# account (uid, shell, groups...) is left to something else to manage — an MDM policy on
	# darwin, for instance — rather than declared here.
	hasSystemUser = def ? "user";
in {
	inherit userName;

	module = let
		user = if hasSystemUser then def.user else null;
		home-manager = if (def ? home-manager) then def.home-manager else null;
		modules = if (def ? modules) then def.modules else [];
	in vars@{ pkgs, lib, ... }: {
		imports = modules;

		# `lib.optional`, not `mkIf`, for the darwin-incompatible pieces below: `mkIf false`
		# still requires the option path it wraps to be *declared* somewhere, and
		# `systemd.tmpfiles` doesn't exist on nix-darwin at all. `lib.optional` keeps the
		# attrset out of the merge entirely when the condition is false, so the option path
		# is never referenced on a platform that doesn't have it.
		config = lib.mkMerge (
			[
				{ home-manager.users.${userName} = lib.mkIf (home-manager != null) home-manager; }
			]
			++ lib.optional hasSystemUser { users.users.${userName} = user vars; }
			++ lib.optional (!hasSystemUser) {
				# home-manager's own NixOS/darwin integration (nixos/common.nix) unconditionally
				# derives home.homeDirectory/home.username from users.users.<name>.home/.name,
				# even with no system account declared here. Supply just enough metadata to
				# satisfy that. This does not create or manage the account itself — nix-darwin
				# only does that for names listed in `users.knownUsers`, which this leaves alone.
				users.users.${userName}.home = lib.mkDefault "/Users/${userName}";
			}
			++ lib.optional (icon != null && hasSystemUser) {
				# https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10
				systemd.tmpfiles.rules = [
					"f+ /var/lib/AccountsService/users/${userName}  0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/${userName}\\n"
					"L+ /var/lib/AccountsService/icons/${userName}  - - - - ${icon}"
				];
			}
		);
	};
}
