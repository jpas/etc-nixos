{ lib, config, ... }:

with lib;

{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@pas.sh";
      group = "acme";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.acme-credentials.path;
    };
  };

  security.acme.certs = {
    "pas.sh" = {
      extraDomainNames = [ "*.pas.sh" ];
    };
    "o.pas.sh" = {
      extraDomainNames = [ "*.o.pas.sh" ];
    };
  };

  age.secrets = {
    acme-credentials = { group = "acme"; file = ./secrets/acme-credentials.age; };
  };

  users.groups.acme = { };
}
