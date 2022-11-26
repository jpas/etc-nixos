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

  age.secrets = {
    acme-credentials = { group = "acme"; file = ./.acme-credentials.age; };
  };

  users.groups.acme = { };
}
