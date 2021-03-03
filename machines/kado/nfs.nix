{ lib
, ...
}:

with lib;

let
  cfg = config.services.nfs;
  toINI = generators.toINI { };
in
{
  services.nfs = {
    extraConfig = toINI {
      nfsd = {
        vers2 = false;
        vers3 = false;
        "vers4.0" = false;
        "vers4.1" = false;
        "vers4.2" = true;
      };

      mountd = { manage-gids = true; };
    };

    server = {
      enable = true;
      exports = ''
        /export      *.o(insecure,rw,async,no_subtree_check,crossmnt,fsid=root)
        /export/data *.o(insecure,rw,async,no_subtree_check)
      '';
    };
  };

  # Only allow traffic from tailscale interface.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 2049 ];
}
