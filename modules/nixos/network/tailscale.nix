{ config, lib, pkgs, ... }:

let

  cfg = config.hole.network.tailscale;

in

{
  options = {
    hole.network.tailscale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.hole.network.enable;
        description = ''
          Whether to enable tailscale networking.
        '';
      };

      hosts = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          "kado.o" = "100.65.152.104";
          "kuro.o" = "100.116.4.62";
          "shiro.o" = "100.69.65.63";
          "beri.o" = "100.104.46.24";
          "doko.o" = "100.68.33.127";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;

    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    networking.hosts = lib.mapAttrs' (host: addr: { name = addr; value = [ host ]; }) cfg.hosts;

    systemd.network.networks = {
      "01-tailscale" = {
        matchConfig.name = "tailscale*";
        linkConfig.Unmanaged = true;
      };
    };

    systemd.services = {
      "tailscaled" = {
        after = [ "systemd-networkd.service" ];
      };

      "tailscale-peer@" = {
        scriptArgs = "%I";
        script =
          let
            tailscale = "${config.services.tailscale.package}/bin/tailscale";
          in
          ''
            until ${tailscale} ping "''$1" > /dev/null; do
              sleep 0.5
            done
          '';

        bindsTo = [ "tailscaled.service" ];
        after = [ "tailscaled.service" ];

        serviceConfig = {
          Type = "oneshot";
          Restart = "on-failure";
          RemainAfterExit = true;
        };
      };
    };
  };
}
