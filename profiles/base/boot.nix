{ lib
, config
, pkgs
, ...
}:

with lib;

let
  loaderCommon = {
    enable = mkDefault false;
    configurationLimit = mkDefault 10;
  };
in
{
  boot.tmpOnTmpfs = mkDefault true;

  boot.kernelPackages = mkDefault (pkgs.linuxPackagesFor pkgs.linux_latest);

  boot.loader = {
    timeout = mkDefault 1;
    efi.canTouchEfiVariables = mkDefault true;

    grub = loaderCommon // {
      efiSupport = mkDefault true;
    };

    systemd-boot = loaderCommon // {
      editor = mkDefault false;
    };

    generic-extlinux-compatible = loaderCommon // { };
  };
}
