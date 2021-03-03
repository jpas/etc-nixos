{ ... }:
{
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend";
  };
}
