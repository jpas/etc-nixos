{ lib, ... }:

with lib;

{
  imports = [
    ../workstation
    ../../hardware/bluetooth.nix
    ../../hardware/wifi.nix
  ];

  services.logind = {
    lidSwitch = mkDefault "suspend";
    lidSwitchDocked = mkDefault "ignore";
    lidSwitchExternalPower = mkDefault "lock";
  };

  # TODO
  #systemd.sleep.extraConfig = ''
  #  [Sleep]
  #  SuspendMode=suspend
  #  HibernateMode=suspend
  #  HibernateState=disk
  #'';

  services.tlp.enable = mkDefault true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
  };

  services.thermald = {
    # Empty config to remove example config from logs
    configFile = mkDefault (builtins.toFile "thermal-conf.xml.empty" ''
      <?xml version="1.0"?>
      <ThermalConfiguration>
      </ThermalConfiguration>
    '');
  };
}
