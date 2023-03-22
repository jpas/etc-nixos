{ lib, config, flakes, pkgs, ... }:

with lib;

{
  imports = [
    ../../../users
    ../../programs/neovim.nix
    ./agenix.nix
    ./boot.nix
    ./colours.nix
    ./flakes.nix
    ./networking.nix
    ./nfs.nix
    ./nix.nix
    ./shell.nix
    ./ssh.nix
    ./tailscale.nix
  ];

  time.timeZone = mkDefault "America/Toronto";
  i18n.defaultLocale = mkDefault "en_CA.UTF-8";

  services.getty.greetingLine =
    "<<< Welcome to NixOS ${config.system.nixos.label} @ ${substring 0 6 config.system.configurationRevision} - \\l >>>";

  services.getty.extraArgs = [ "--nonewline" ];

  # Does not enable xserver, but make sure the keymap is in sync
  services.xserver.layout = mkDefault "us";
  console.useXkbConfig = mkDefault true;

  virtualisation.oci-containers.backend = mkDefault "podman";

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  programs._1password.enable = mkDefault true;
}
