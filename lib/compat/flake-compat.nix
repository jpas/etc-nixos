let
  flake = (import flake-compat) { src = ../../..; };

  lock = builtins.fromJSON (builtins.readFile ../../../flake.lock);

  flake-compat =
    let
      inherit (lock.nodes.flake-compat.locked) rev narHash;
    in
    fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/${rev}.tar.gz";
      sha256 = narHash;
    };
in
flake.defaultNix
