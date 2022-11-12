{ lib, config, ... }:

with lib;

{
  options = {
    hole.microcode = {
      enable = mkEnableOption "cpu microcode updates";
      vendor = mkOption { type = types.enum [ "intel" "amd" ]; };
    };
  };

  config = mkIf config.hole.microcode.enable {
    hardware.cpu.intel.updateMicrocode = (config.hole.microcode.vendor == "intel");
    hardware.cpu.amd.updateMicrocode = (config.hole.microcode.vendor == "amd");
  };
}
