{ config, lib, ... }:

with lib;

let

  cfg = config.hole.use;

in
{
  options.hole.use.laptop = mkEnableOption "laptop";

  config = mkIf cfg.laptop {
    services.logind = {
      lidSwitch = mkDefault "suspend";
      lidSwitchDocked = mkDefault "ignore";
      lidSwitchExternalPower = mkDefault "lock";
      # extraConfig = ''
      #   HandlePowerKey=suspend
      #   HandleSuspendKey=suspend
      # '';
    };

    # systemd.sleep.extraConfig = ''
    #   [Sleep]
    #   SuspendMode=suspend
    #   HibernateMode=suspend
    #   HibernateState=disk
    # '';

    # services.upower = {
    #   enable = mkDefault true;
    #   criticalPowerAction = mkDefault "HybridSleep";
    # };

    services.tlp.enable = mkDefault true;

    services.thermald = mkIf config.hole.use.intel-cpu {
      enable = mkDefault true;
      # Empty config to remove example config from logs
      configFile = mkDefault (builtins.toFile "thermal-conf.xml.empty" ''
        <?xml version="1.0"?>
        <ThermalConfiguration>
        </ThermalConfiguration>
      '');
    };
  };
}
