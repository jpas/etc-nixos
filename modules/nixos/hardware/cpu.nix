{ lib
, config
, ...
}:


let
  cfg = config.hole.hardware.cpu;
in
{
  options.hole.hardware.cpu.intel.enable = mkEnableOption "intel cpu config";
  options.hole.hardware.cpu.amd.enable = mkEnableOption "amd cpu config";

  config = mkMerge [
    (mkIf cfg.amd.enable {
    })

    (mkIf cfg.intel.enable {
      services.thermald = {
        enable = mkDefault true;
        # Empty config to remove example config from logs
        configFile = lib.mkDefault (builtins.toFile "thermal-conf.xml.empty" ''
          <?xml version="1.0"?>
          <ThermalConfiguration>
          </ThermalConfiguration>
        '');
      };
    })
  ];
}
