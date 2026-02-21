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

  security.acme.certs = lib.genAttrs
    [ "jarrodpas.com" "jpas.dev" "jpas.xyz" "pas.sh" "o.pas.sh" ]
    (domain: {
      extraDomainNames = [ "*.${domain}" ];
    });

  age.secrets = {
    acme-credentials = { group = "acme"; file = ./secrets/acme-credentials.age; };
  };

  users.groups.acme = { };
}
