{ lib, config, pkgs, ... }:

with lib;

{
  containers.torrents = {
    nixpkgs = pkgs;
    autoStart = true;
    ephemeral = true;
    privateNetwork = true;

    config = { config, ... }: {
      services.transmission.enable = true;

      systemd.networks."vpn0" = {
        matchConfig = {
          Name = "vpn0";
        };
        networkConfig = {
          Address = [ "10.64.111.136/32" "fc00:bbbb:bbbb:bb01::2:6f87/128" ];
          DNS = [ "10.64.0.1" ];
        };
        routeConfig = {
          Gateway = "10.64.111.136";
        };
      };
      systemd.netdevs."vpn0" = {
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.torrents-vpn-private-key.path;
        };
        wireguardPeers = [{
          PublicKey = "9PfLtMmfLsdNuh3Rj3eBDMId2bXZ7+yWJO78CZfuLzU=";
          AllowedIPs = [ "0.0.0.0/0" "::0/0" ];
          Endpoint = "198.54.132.82:51820";
        }];
      };

      age.secrets.torrents-vpn-private-key = {
        file = ./.torrents-vpn-private-key.age;
        owner = "root";
        group = "systemd-network";
        mode = "0440";
      };
    };
  };
}
