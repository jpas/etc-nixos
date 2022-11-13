{ lib, ... }:

with lib;

{
  xdg.mime.addedAssociations = {
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
  };

  environment.etc."sway/config.d/zathura.conf".text = ''
    for_window [app_id="org.pwmt.zathura"] floating enable
  '';
}
