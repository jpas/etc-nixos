{ lib, ... }:

with lib;

{
  imports = [
    ./tailscale.nix
    ./wireless.nix
  ];

  networking.useDHCP = false;
  networking.useNetworkd = true;
  systemd.services.systemd-networkd-wait-online.enable = false;

  systemd.network.links."98-default" = {
    matchConfig.Name = "*";
    linkConfig = {
      NamePolicy = "keep kernel database onboard slot path mac";
      AlternativeNamesPolicy = "database onboard slot path mac";
      MACAddressPolicy = "persistent";
    };
  };

  systemd.network.networks."20-lan0" = {
    dhcpV4Config.ClientIdentifier = mkDefault "mac";
  };

  systemd.network.networks."98-default" = {
    matchConfig.Name = "*";
    linkConfig.Unmanaged = true;
  };
}
