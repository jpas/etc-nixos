{ flake
, pkgs
, ...
}:

{
  imports = [
    ../../profiles/base.nix
    "${flake.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_5_14;
}