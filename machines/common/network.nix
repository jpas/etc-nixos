{ lib
, config
, pkgs
, ...
}:

with lib;

let
  hole = {
    kado = "100.65.152.104";
    kuro = "100.116.4.62";
    shiro = "100.69.65.63";
  };

  mkHosts = hosts: domain:
    mapAttrs'
      (host: ip: {
        name = ip;
        value = [ (host + domain) ];
      })
      hosts;
in
{

  config = mkMerge [
    {
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
      networking.hosts = mkHosts hole ".o";
    }

    (mkIf config.services.tailscale.enable {
      systemd.services = {
        "iwd" = {
          requires = [ "dbus.service" ];
          after = [ "dbus.service" ];
        };

        "tailscaled" = {
          requires = [ "network-online.target" ];
          after = [ "network-online.target" ];
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
    })
  ];
}
