{ lib, config, ... }:

with lib;


let
  cfg = config.services.kresd;

  blocklist-version = "331552d819fef1a988f92dc220d8b2b05e058705";
  blocklist = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ScriptTiger/scripttiger.github.io/${blocklist-version}/alts/rpz/blacklist.txt";
    hash = lib.fakeHash;
  };
in
mkIf cfg.enable {
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.kresd = {
    listenPlain = [ "0.0.0.0:53" "[::]:53" ];
    extraConfig = ''
      policy.add(policy.rpz(policy.DENY(),'${blocklist}',false))
      policy.add(polciy.all(policy.TLS_FORWARD({
        {'1.1.1.1', hostname="cloudflare-dns.com"},
        {'1.0.0.1', hostname="cloudflare-dns.com"},
        {'2606:4700:4700::1111', hostname="cloudflare-dns.com"},
        {'2606:4700:4700::1001', hostname="cloudflare-dns.com"}
      })
    '';
  };
}
