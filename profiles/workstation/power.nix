{ lib
, ...
}:

with lib;

{
  services.upower.enable = mkDefault true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    HandlePowerKeyLongPress=poweroff
  '';
}
