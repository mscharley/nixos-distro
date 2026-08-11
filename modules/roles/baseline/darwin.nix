{ pkgs, ... }:
{
  # Every once in a while, nix-darwin may change configuration defaults in a way
  # incompatible with stateful data. Pin to the current release to avoid surprise
  # changes; bump deliberately after reading `darwin-rebuild changelog`.
  system.stateVersion = 7;

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    fira-code
    victor-mono
  ];

  # No `programs.nh` module on darwin; install it as a plain package instead.
  # config.distro.editor mirrors roles/baseline/nixos.nix's `nano config.distro.editor` —
  # the option itself is declared in modules/config (shared), but nothing installs it
  # unless a consumer both sets it and lists it here.
  environment.systemPackages = with pkgs; [
    nh

    # macOS lacks these entirely (BSD userland, no GNU coreutils/sed) — the old
    # Homebrew Brewfile installed them `if OS.mac?` for exactly this reason.
    coreutils
    gnused
    watch
  ];

  # programs.fish.enable/programs.zsh.enable (shared.nix) only set up the shell's own
  # integration — they don't register anything in /etc/shells. Without this,
  # nix-darwin leaves /etc/shells untouched entirely (its own module only writes the
  # file when environment.shells is non-empty), so the Homebrew-installed fish stays
  # the only valid login shell and nix's own build is never chsh-able.
  environment.shells = [
    pkgs.fish
    pkgs.zsh
  ];
}
