{ lib
, config
, ...
}:

with lib;

let
  cfg = config.servies.gitea;
in
{
  servies.gitea.enable = true;
  servies.gitea = {
    database.type = "sqlite";

    domain = "git.pas.sh";
    rootUrl = "https://${cfg.domain}/";
    httpAddress = "127.0.0.1";
    httpPort = 3000;
  };

  services.traefik.dynamicConfigOptions.http = mkIf cfg.enable {
    services.gitea = {
      loadBalancer.servers = [{ url = "http://${cfg.httpAddress}:${toString cfg.httpPort}"; }];
    };

    routers.gitea = {
      rule = "Host(`${cfg.domain}`)";
      service = "gitea";
      entryPoints = [ "web" ];
    };
  };
}
