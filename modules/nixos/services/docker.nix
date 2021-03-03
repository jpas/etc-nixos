{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.virtualisation.docker;
in
{
  virtualisation.docker = {
    autoPrune.enable = mkDefault cfg.enable;
  };

  environment.systemPackages = mkIf cfg.enable [
    pkgs.docker-compose
  ];
}
