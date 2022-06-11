{ flake
, pkgs
, ...
}:

{
  # install iso

  imports = [
    "${flake.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  hole.network.wifi = true;
  hole.hardware.sound = true;

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux;
}
