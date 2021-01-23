{ lib, config, pkgs, ... }:
with lib;
{
  virtualisation.docker = {
    autoPrune.enable = mkDefault config.virtualisation.docker.enable;
  };

  environment.systemPackages = mkIf config.virtualisation.docker.enable [
    pkgs.docker-compose
  ];
}
