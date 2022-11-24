{ lib, pkgs, config, ... }:

with lib;

flip pipe config.users.users [
  attrValues
  (filter (user: user.isNormalUser))
  (user: {
    networking.firewall.allowedTCPPorts = [ (21000 + user.uid) ];

    containers."syncthing-${name}" = {
      bindMounts = genAttrs [ "/aleph/home/${user.name}" "/aleph/home/share" ]
        (path: { hostPath = path; isReadOnly = false; });
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
          inherit (user) uid gid;
          createHome = false;
          home = "/var/empty";
          shell = "/run/current-system/sw/bin/nologin";
        };

        system.stateVersion = config.system.stateVersion;
      };
    };
  })
  mkMerge
]
