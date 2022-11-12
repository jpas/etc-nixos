{ lib, ... }:

with lib;

let
  enable = false;
in
mkIf enable {
  services.nginx.virtualHosts = {
    "dl.pas.sh" = {
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        autoindex on;
        autoindex_exact_size off;
      '';

      locations."/" = {
        root = "/srv/dl";
      };
    };
  };
}
