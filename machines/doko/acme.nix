{ lib, config, ... }:

with lib;

{
  security.acme.defaults = {
    acceptTerms = true;
    email = "acme@pas.sh";
    dnsProvider = "cloudflare";
    credentialsFile = config.age.secrets.acme-credentials.path;
  };

  age.secrets = {
    acme-credentials = { group = "acme"; file = ./.acme-credentials.age; };
  };
}
