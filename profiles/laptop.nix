{ lib
, config
, ...
}:

with lib;

{
  options = {
    profiles.laptop = mkEnableOption "laptop profile";
  };

  config = mkIf config.profiles.laptop (mkMerge [
    {
      services.logind = {
        lidSwitch = mkDefault "suspend-then-hibernate";
        lidSwitchDocked = mkDefault "ignore";
        lidSwitchExternalPower = mkDefault "lock";
        extraConfig = ''
          HandlePowerKey=suspend-then-hibernate
          HandleSuspendKey=suspend-then-hibernate
          HandleSuspendKey=suspend-then-hibernate
        '';
      };

      systemd.sleep.extraConfig = ''
        [Sleep]
        HibernateMode=suspend
        HibernateState=disk
      '';
    }

    {
      powerManagement.enable = mkDefault true;

      # touchpad drivers
      services.xserver.libinput.enable = mkDefault true;

      # laptop thermal management
      services.tlp.enable = mkDefault true;
      services.thermald.enable = mkDefault true;
    }
 ]);
}
