{ lib, ... }:

with lib;

let
  toINI = generators.toINI { };
in {
  services.nfs = {
    extraConfig = toINI {
      nfsd = {
        host = "100.65.152.104"; # TODO: get tailscale IPs from somewhere
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

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
    2049
  ];
}
