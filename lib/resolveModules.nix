# Resolves a list of role/service/form-factor names into the concrete module paths for a
# given platform. Each module lives under `modules/<kind>/<name>/` and may provide
# `shared.nix`, `nixos.nix`, and/or `darwin.nix` — whichever exist are included, in that
# order. A name with no implementation for the current platform contributes nothing rather
# than erroring, so platform-specific lists (e.g. a NixOS-only "gaming" role) are simply
# skipped when resolved for "darwin".
lib: platform: kind: names:
lib.concatMap (
  name:
  let
    dir = ../modules + "/${kind}/${name}";
  in
  lib.optional (builtins.pathExists (dir + "/shared.nix")) (dir + "/shared.nix")
  ++ lib.optional (builtins.pathExists (dir + "/${platform}.nix")) (dir + "/${platform}.nix")
) names
