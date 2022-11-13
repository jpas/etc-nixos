{ lib, ... }:

{
  environment.etc."sway/config.d/imv.conf".text = ''
    for_window [app_id="imv"] floating enable, border normal
  '';
}
