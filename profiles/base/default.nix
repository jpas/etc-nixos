{ lib, config, flakes, pkgs, ... }:

with lib;

{
  imports = [
    ../../users
    ./networking
    ./nfs.nix
    ./agenix.nix
    ./bluetooth.nix
    ./boot.nix
    ./colours.nix
    ./default.nix
    ./flakes.nix
    ./home-manager.nix
    ./microcode.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
  ];

  time.timeZone = mkDefault "America/Toronto";
  i18n.defaultLocale = mkDefault "en_CA.UTF-8";

  # Does not enable xserver, but make sure the keymap is in sync
  services.xserver.layout = mkDefault "us";
  console.useXkbConfig = mkDefault true;

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';
}
