{ lib
, config
, pkgs
, ...
}:

with lib;

{

  config = mkMerge [
    {
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
      networking.hosts = {
        "100.65.152.104" = [ "kado.o" ];
        "100.116.4.62" = [ "kuro.o" ];
        "100.69.65.63" = [ "shiro.o" ];
        "100.104.46.24" = [ "beri.o" ];
        "100.68.33.127" = [ "doko.o" "ht.pas.sh" "git.ht.pas.sh" "meta.ht.pas.sh" "paste.ht.pas.sh" ];
      };
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
