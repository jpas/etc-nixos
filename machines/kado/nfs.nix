{ ... }:
{
  services.nfs = {
    server = {
      enable = true;
      exports = ''
        /srv/exports        *.o(insecure,rw,async,no_subtree_check,crossmnt,fsid=root)
        /srv/exports/aleph  *.o(insecure,rw,async,no_subtree_check)
      '';
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 2049 ];
}
