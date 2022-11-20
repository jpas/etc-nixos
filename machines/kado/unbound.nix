{ lib, config, ... }:

with lib;


let
  cfg = config.services.unbound;
in
mkIf cfg.enable {
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.resolved.extraConfig = ''
    [Resolve]
    DNS=127.0.0.1
    DNSStubListener=no
  '';

  services.unbound = {
    settings = {
      server = {
        access-control = [
          "127.0.0.0/8 allow"
          "10.0.0.0/8 allow"
        ];
        interface = [
          "127.0.0.1"
          "10.39.0.20"
        ];
        local-zone = [
          "\"pas.sh\" transparent"
          "\"jpas.xyz\" transparent"
        ];
        local-data = [
          "\"sonarr.jpas.xyz A 10.39.0.20\""
          "\"radarr.jpas.xyz A 10.39.0.20\""
          "\"jellyfin.jpas.xyz A 10.39.0.20\""
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1"
            "1.0.0.1"
            "2606:4700:4700::1111"
            "2606:4700:4700::1001"
          ];
        }
      ];
    };
  };
}
