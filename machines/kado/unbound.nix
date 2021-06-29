{ lib
, config
, ...
}:

with lib;


let
  cfg = config.services.unbound;
in
mkMerge [
  {
    services.unbound.enable = false;
  }

  (mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 53 ];

    services.unbound = {
      settings = {
        server = {
          interface = [ "0.0.0.0" "::0" ];
          access-control = [
            "10.0.0.0/8 allow"
            "100.0.0.0/8 allow"
          ];
        };
        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "1.1.1.1"
              "1.0.0.1"
            ];
          }
        ];
      };
    };
  })
]
