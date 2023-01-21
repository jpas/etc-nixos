{ lib, config, flakes, pkgs, ... }:

with lib;

let
  common = { configurationLimit = mkDefault 10; };
in
{
  boot.kernelPackages = mkDefault (pkgs.linuxPackagesFor pkgs.linux_latest);
  boot.tmpOnTmpfs = mkDefault true;
  boot.loader = {
    timeout = mkDefault 1;
    grub = common // {
      enable = false;
    };
    systemd-boot = common // {
      enable = config.nixpkgs.hostPlatform == "x86_64-linux";
      editor = false;
    };
    generic-extlinux-compatible = common // {
      enable = config.nixpkgs.hostPlatform == "aarch64-linux";
    };
  };
}
