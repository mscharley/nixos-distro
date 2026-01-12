username: { user, home-manager ? null, modules ? [] }: vars@{ pkgs, lib, ... }: {
	imports = modules;

	users.users.${username} = user vars;
	home-manager.users.${username} = home-manager;
}
