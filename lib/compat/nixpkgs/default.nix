let
  flake = import ./flake-compat.nix;
  nixos = import ./nixos { };

  nixpkgs = flake.inputs.nixpkgs.outPath;

  configArgs = {
    inherit (nixos.config.nixpkgs) config overlays localSystem crossSystem;
  };

in
  { ... } @ args: import nixpkgs (configArgs // args)
