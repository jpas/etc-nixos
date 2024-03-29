# To build the iso run the following. It will be at ./result/iso/nixos-*.iso
# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=/path/to/install-iso.nix
{ lib
, pkgs
, ...
}:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ../profiles/base
  ];

  hardware.enableRedistributableFirmware = true;

  environment.defaultPackages = [
    pkgs.restic
    pkgs.nvme-cli
    pkgs.cryptsetup
  ];

  networking.wireless.enable = false;
  networking.wireless.iwd.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
