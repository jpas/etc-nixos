{ lib, config, pkgs, flakes, ... }:

with lib;

{
  networking.hostName = "beri";
  boot.loader.generic-extlinux-compatible.enable = true;

  imports = [
    "${flakes.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    ../../profiles/archetype/minimal
    ../common
  ];

  systemd.network.networks = {
    "20-lan" = {
      matchConfig.Name = "enx*";
      linkConfig = {
        RequiredForOnline = "routable";
      };
      networkConfig = {
        DHCP = "yes";
      };
    };
  };

  # source: https://github.com/NixOS/nixpkgs/commit/d91e1f98fa83fecf614111b3bfde9bf2b3c3aa3d

  # Makes `availableOn` fail for zfs, see <nixos/modules/profiles/base.nix>.
  # This is a workaround since we cannot remove the `"zfs"` string from `supportedFilesystems`.
  # The proper fix would be to make `supportedFilesystems` an attrset with true/false which we
  # could then `lib.mkForce false`
  nixpkgs.overlays = [(final: super: {
    zfs = super.zfs.overrideAttrs(_: {
      meta.platforms = [];
    });
  })];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
