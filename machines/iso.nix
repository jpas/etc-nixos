{ flakes }:

{
  imports = [
    ${flake.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
  ];
}
