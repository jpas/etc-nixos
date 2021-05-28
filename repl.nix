let
  flake = builtins.getFlake (toString ./.);
  pkgs = flake.legacyPackages."${builtins.currentSystem}";
in flake // { inherit flake pkgs; }
