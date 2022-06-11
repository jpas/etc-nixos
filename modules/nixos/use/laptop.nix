{ lib
, config
, ...
}:

with lib;

let

  cfg = config.hole.profile.laptop;

in
{
  options.hole.profile.laptop = mkEnableOption "laptop";

  config = mkIf cfg.enable {
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
    services.xserver.libinput.enable = mkDefault true;

    services.thermald = mkIf config.hole.hardware.cpu.intel {
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
