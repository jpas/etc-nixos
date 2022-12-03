{ lib, config, flakes, pkgs, ... }:

with lib;

{
  imports = [
    ../../users
    ./agenix.nix
    ./bluetooth.nix
    ./boot.nix
    ./colours.nix
    ./flakes.nix
    ./home-manager.nix
    ./kanidm.nix
    ./microcode.nix
    ./networking
    ./nfs.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
    ./xdg.nix
  ];

  time.timeZone = mkDefault "America/Toronto";
  i18n.defaultLocale = mkDefault "en_CA.UTF-8";

  # Does not enable xserver, but make sure the keymap is in sync
  services.xserver.layout = mkDefault "us";
  console.useXkbConfig = mkDefault true;

  virtualisation.oci-containers.backend = mkDefault "podman";

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';
}
