{ lib, config, pkgs, ...}:

let

  cfg = config.hole.network;

in

{
  imports = [
    ./tailscale.nix
    ./wifi.nix
  ];

  options = {
    hole.network = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable network config.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.useDHCP = false;
    networking.useNetworkd = true;

    systemd.services.systemd-networkd-wait-online.enable = mkDefault false;

    systemd.network.links = {
      "98-default" = {
        matchConfig.OriginalName = "*";
        linkConfig = {
          NamePolicy = "keep kernel database onboard slot path mac";
          AlternativeNamesPolicy = "database onboard slot path mac";
          MACAddressPolicy = "persistent";
        };
      };
    };

    systemd.network.networks = {
      "98-default" = {
        matchConfig.OriginalName = "*";
        linkConfig.Unmanaged = true;
      };
    };
  };
}
