{ lib, ... }:

with lib;

{
  nix = {
    optimise.automatic = mkDefault true;

    gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 30d";
    };

    settings = {
      trusted-users = [ "root" "@wheel" ];
      allowed-users = [ "@users" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # see: https://github.com/NixOS/nixpkgs/issues/54707#issuecomment-1132907191
  systemd.services.dix-daemon.environment.TMPDIR = "/nix/tmp";
  systemd.tmpfiles.rules = [ "d /nix/tmp 0755 root root 1d" ];
}
