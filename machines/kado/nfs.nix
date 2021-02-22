{ lib, ... }:

with lib;

let
  mkExports = e: "";

  exports = {
    "/export" = {
      options = [ "rw" "fsid=0" "no_subtree_check" ];
    };
  };

in {
  services.nfs = {
    extraConfig = toINI {
      nfsd = {
        host = hosts.kuro;
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
        /export      *.hole(insecure,rw,sync,no_subtree_check,crossmnt,fsid=root)
        /export/data *.hole(insecure,rw,sync,no_subtree_check)
      '';
    };
  };
}
