{ lib
, config
, ...
}:

with lib;

{
  config = mkIf (config.hole.profiles ? laptop) (mkMerge [
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

      systemd.sleep.extraConfig = ''
        [Sleep]
        SuspendMode=suspend
        SuspendState=disk
        HibernateMode=suspend
        HibernateState=disk
      '';

      services.upower = {
        enable = mkDefault true;
        criticalPowerAction = mkDefault "HybridSleep";
      };
    }

    {
      services.thermald.enable = mkDefault true;
      services.tlp.enable = mkDefault true;
      services.xserver.libinput.enable = mkDefault true;
    }
  ]);
}
