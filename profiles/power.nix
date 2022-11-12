{ lib, config, pkgs, ... }:

with lib;

{
  services.logind = {
    lidSwitch = mkDefault "suspend";
    lidSwitchDocked = mkDefault "ignore";
    lidSwitchExternalPower = mkDefault "lock";
    extraConfig = ''
      HandlePowerKey=suspend
      HandleSuspendKey=suspend
    '';
  };

  # systemd.sleep.extraConfig = ''
  #   [Sleep]
  #   SuspendMode=suspend
  #   HibernateMode=suspend
  #   HibernateState=disk
  # '';

  services.upower = {
    enable = mkDefault true;
    criticalPowerAction = mkDefault "Suspend";
  };

  services.tlp.enable = mkDefault true;

  services.thermald = {
    # Empty config to remove example config from logs
    configFile = mkDefault (builtins.toFile "thermal-conf.xml.empty" ''
      <?xml version="1.0"?>
      <ThermalConfiguration>
      </ThermalConfiguration>
    '');
  };
}
