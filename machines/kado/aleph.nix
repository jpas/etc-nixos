{ lib
, pkgs
, config
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
        options = [
          "autodefrag"
          "commit=5"
          "relatime"
          "space_cache=v2"
          "subvol=/aleph"
        ];
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

  syncthingFor = name:
    let
      user = config.users.users."${name}";
      folders = [ "/aleph/home/${name}" "/aleph/home/share" ];
    in
    {
      networking.firewall.allowedTCPPorts = [ (21000 + user.uid) ];
      containers."syncthing-${name}" = {
        bindMounts = genAttrs folders (path: {
          hostPath = path;
          isReadOnly = false;
        });
        autoStart = true;

        # TODO: declarative config file
        # TODO: default folder path
        config = { ... }: {
          nixpkgs.pkgs = pkgs;

          services.syncthing = {
            enable = true;
            systemService = true;
            user = user.name;
            group = "users";
          };

          systemd.services.syncthing = {
            serviceConfig = {
              StateDirectory = "syncthing";
            };
          };

          users.users."${name}" = {
            inherit (user) uid isNormalUser;
            createHome = false;
            home = "/var/empty";
            shell = "/run/current-system/sw/bin/nologin";
          };
        };
      };
    };

  syncthing = mkMerge (map syncthingFor [
    # "jpas"
    "kbell"
  ]);

in
mkMerge [ mount nfs syncthing ]
