{ ... }:
{
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
    extraConfig = ''
      HandleSuspendKey=suspend-then-hibernate
    '';
  };

  systemd.sleep.extraConfig = ''
    [Sleep]
    HibernateMode=suspend
    HibernateState=disk
  '';
}
