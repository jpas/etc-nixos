{ flake
, pkgs
, ...
}:

{
  # install iso

  imports = [
    "${flake.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  hole.network.wifi.enable = true;
  hole.network.tailscale.enable = false;

  hole.use.sound = true;

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux;
}
