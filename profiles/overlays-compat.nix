{ pkgs
, options
, ...
}:

let
  overlays-compat = pkgs.writeTextFile {
    name = "overlays-compat";
    destination = "/overlays.nix";
    text = ''
      final: prev:

      with prev.lib;

      let
        # Load the system config and get the `nixpkgs.overlays` option
        overlays = (import <nixpkgs/nixos> { }).config.nixpkgs.overlays;
      in
        # Apply all overlays to the input of the current "main" overlay
        foldl' (flip extends) (_: prev) overlays final
    '';
  };
in
{
  nix.nixPath =
    options.nix.nixPath.default ++ [ "nixpkgs-overlays=${overlays-compat}" ];
}
