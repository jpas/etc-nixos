{ lib
, ...
}:

with lib;

{
  networking.wireless.iwd.enable = mkDefault true;
}
