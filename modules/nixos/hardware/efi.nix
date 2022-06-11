{ lib
, config
, ...
}:

let
  cfg = config.hole.hardware.efi;
{
  options.hole.hardware.efi.enable = mkEnableOption "efi";

  config = mkIf cfg.enable {
    boot.loader = {
      efi.canTouchEfiVariables = mkDefault true;

      grub.enable = mkDefault false;

      systemd-boot = {
        enable = mkDefault true;
        editor = mkDefault false;
      };
    };
  };
}
