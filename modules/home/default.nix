builtins.mapAttrs (_: p: import p) {
  bat = ./bat.nix;
  hole = ./hole.nix;
  imv = ./imv.nix;
  oauth2ms = ./oauth2ms.nix;
  signal = ./signal.nix;
}
