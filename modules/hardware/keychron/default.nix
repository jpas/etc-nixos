{ lib
, ...
}:
{
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
}
