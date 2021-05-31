{ lib
, ...
}:

with lib;

let
  mount = {
    services.btrfs.autoScrub = {
      enable = true;
      interval = "Wed *-*-1..7 4:00";
      fileSystems = [ "/aleph" ];
    };

    fileSystems = {
      "/aleph" = {
        device = "/dev/disk/by-uuid/8aebe979-4cbd-45c6-a83e-44a165be7226";
        fsType = "btrfs";
        options = [ "subvol=/aleph" "space_cache=v2" "autodefrag" "relatime" ];
      };
    };
  };

  nfs = {
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

    fileSystems = {
      "/srv/exports/aleph" = {
        device = "/aleph";
        options = [ "bind" ];
      };
    };
  };

  syncthing = {
    services.syncthing = {
      enable = true;
      systemService = true;
      declarative.folders = {
        "/aleph/home/kbell" = {
          id = "aleph-home-kbell";
          copyOwnershipFromParent = true;
        };
        "/aleph/home/share" = {
          id = "aleph-home-share";
          copyOwnershipFromParent = true;
        };
      };
    };

    systemd.services.syncthing = {
      serviceConfig = {
        AmbientCapabilities = [ "CAP_CHOWN" ];
      };
    };
  };

in
mkMerge [ mount nfs syncthing ];

