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
        '';
      };

      systemd.sleep.extraConfig = ''
        [Sleep]
        HibernateMode=suspend
        HibernateState=disk
      '';
    }

    {
      hardware.bluetooth.enable = mkDefault true;

      networking.wireless.iwd.enable = mkDefault true;

      powerManagement.enable = mkDefault true;

      services.thermald.enable = mkDefault true;
      services.tlp.enable = mkDefault true;
      services.xserver.libinput.enable = mkDefault true;
    }
  ]);
}
