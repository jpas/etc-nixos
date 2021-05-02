{ lib
, ...
}:

with lib;

{
  powerManagement.enable = mkDefault true;

  services.tlp.enable = mkDefault true;

  services.xserver.libinput.enable = mkDefault true;
}
