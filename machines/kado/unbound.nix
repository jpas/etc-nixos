{ lib
, ...
}:

{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = [ "0.0.0.0" "::0" ];
        access-control = [ "10.0.0.0/8" "100.0.0.0/8" ];
        forward-zone = [
          {
            name = ".";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"
            ];
          }
        ];
      };
    };
  };
}
