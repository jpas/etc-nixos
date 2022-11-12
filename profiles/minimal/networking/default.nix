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

  systemd.network = {
    links."98-default" = {
      matchConfig.OriginalName = "*";
      linkConfig = {
        NamePolicy = "keep kernel database onboard slot path mac";
        AlternativeNamesPolicy = "database onboard slot path mac";
        MACAddressPolicy = "persistent";
      };
    };
    networks."98-default" = {
      matchConfig.OriginalName = "*";
      linkConfig.Unmanaged = true;
    };
  };
}
