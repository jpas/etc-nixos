{ lib
, config
, ...
}:

with lib;

let
  cfg = config.hole.networking;
in
{
  options.hole.networking = {
    enable = mkEnableOption "networking";

    dhcp = mkEnableOption "dhcp";
  };

  config = mkMerge [
    {
      hole.networking.dhcp = mkDefault true;
    }

    (mkIf cfg.enable {
    })
  ];
}
