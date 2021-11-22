{ flake
, ...
}:

{
  imports = [
    ../common
    "${flake.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];
}
