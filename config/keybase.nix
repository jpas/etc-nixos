{ config, pkgs, ... }:
{
  # Enable the Keybase daemon and filesystem.
  #services.keybase.enable = true;
  #services.kbfs.enable = true;

  #environment.systemPackages =
  #  if config.services.xserver.enable
  #  then [ pkgs.keybase-gui ]
  #  else [];
}
