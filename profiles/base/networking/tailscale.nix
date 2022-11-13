{ lib, config, ... }:

with lib;

{
  services.tailscale.enable = mkDefault true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.checkReversePath = "loose";

  networking.extraHosts = ''
    100.69.65.63    shiro.o
    100.68.33.127   doko.o
    100.65.152.104  kado.o
    100.116.4.62    kuro.o
  '';

  systemd.network.networks."01-tailscale" = {
    matchConfig.name = "tailscale*";
    linkConfig.Unmanaged = true;
  };

  systemd.services.tailscaled = {
    bindsTo = [ "systemd-networkd.service" ];
    after = [ "systemd-networkd.service" ];
  };

  systemd.services."tailscale-peer@" = {
    scriptArgs = "%I";
    script = let tailscale = config.services.tailscale.package; in ''
      until ${tailscale}/bin/tailscale ping "''$1" > /dev/null; do
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
}
