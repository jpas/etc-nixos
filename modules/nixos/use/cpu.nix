{ config, lib, ... }:

with lib;

let

  cfg = config.hole.use;

in

{
  options = {
    hole.use.intel-cpu = mkEnableOption "intel cpu config";
    hole.use.amd-cpu = mkEnableOption "amd cpu config";
    hole.use.arm-cpu = mkEnableOption "arm cpu config";
    hole.use.efi = mkEnableOption "efi config";
  };

  config = mkMerge [
    (mkIf cfg.amd-cpu {
      hole.use.efi = mkDefault true;
    })

    (mkIf cfg.intel-cpu {
      hole.use.efi = mkDefault true;
      hardware.cpu.intel.updateMicrocode = true;
    })

    (mkIf cfg.arm-cpu {
      boot.loader = {
        generic-extlinux-compatible.enable = true;
        grub.enable = false;
      };
    })

    (mkIf cfg.efi {
      boot.loader = {
        efi.canTouchEfiVariables = mkDefault true;
        grub.enable = mkDefault false;
        systemd-boot.enable = mkDefault true;
      };
    })
  ];
}
