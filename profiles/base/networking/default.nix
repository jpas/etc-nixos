{ lib, ... }:

with lib;

{
  imports = [
    ./tailscale.nix
    ./wireless.nix
  ];

  networking.useDHCP = mkDefault false;
  networking.useNetworkd = mkDefault true;
  systemd.services.systemd-networkd-wait-online.enable = mkDefault false;

  systemd.network.links."98-default" = {
    matchConfig.Name = "*";
    linkConfig = {
      NamePolicy = "keep kernel database onboard slot path mac";
      AlternativeNamesPolicy = "database onboard slot path mac";
      MACAddressPolicy = "persistent";
    };
  };

  systemd.network.networks."20-lan" = {
    dhcpV4Config.ClientIdentifier = "mac";
  };

  systemd.network.networks."98-default" = {
    matchConfig.Name = "*";
    linkConfig.Unmanaged = true;
  };
}
