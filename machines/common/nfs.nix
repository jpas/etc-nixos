{ lib
, ...
}:

with lib;

{
  services.nfs = {
    extraConfig = generators.toINI { } {
      nfsd = {
        vers2 = false;
        vers3 = false;
        "vers4.0" = false;
        "vers4.1" = false;
        "vers4.2" = true;
      };
      mountd = { manage-gids = true; };
    };
  };

  # We do not need any of these for nfs4
  systemd.sockets.rpcbind.enable = false;
  systemd.services.rpcbind.enable = false;
  systemd.services."rpc-statd".enable = false;
  systemd.services."rpc-statd-notify".enable = false;
}
