{ lib, ... }: {
  services.thermald = {
    # Empty config to remove example config from logs
    configFile = lib.mkDefault (builtins.toFile "thermal-conf.xml.empty" ''
      <?xml version="1.0"?>
      <ThermalConfiguration>
      </ThermalConfiguration>
    '');
  };
}
