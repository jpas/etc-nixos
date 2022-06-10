{ lib
, config
, ...
}:

with lib;

{
  options.hole.hardware.laptop.enable = mkEnableOption "laptop";

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

    services.thermald.enable = mkDefault true;
    services.tlp.enable = mkDefault true;
    services.xserver.libinput.enable = mkDefault true;
  };
}
