{ config, lib, ... }:

with lib;

let

  cfg = config.hole.use;

in

{
  options = {
    hole.use.intel-cpu = mkEnableOption "intel cpu config";
    hole.use.amd-cpu = mkEnableOption "amd cpu config";
    hole.use.efi = mkEnableOption "efi config";
  };

  config = mkMerge [
    (mkIf cfg.amd {
      hole.use.efi = mkDefault true;
    })

    (mkIf cfg.intel {
      hole.use.efi = mkDefault true;
    })

    (mkIf cfg.efi {
      boot.loader = {
        efi.canTouchEfiVariables = mkDefault true;

        grub.enable = mkDefault false;

        systemd-boot = {
          enable = mkDefault true;
          editor = mkDefault false;
        };
      };
    })
  ];
}
