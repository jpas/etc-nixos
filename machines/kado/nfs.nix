{ ... }:
{
  services.nfs = {
    server = {
      enable = true;
      exports = ''
        /export      *.o(insecure,rw,async,no_subtree_check,crossmnt,fsid=root)
        /export/data *.o(insecure,rw,async,no_subtree_check)
      '';
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 2049 ];
}
