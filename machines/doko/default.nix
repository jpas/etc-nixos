{ lib
, pkgs
, ...
}:

{
  networking.hostName = "doko";
  nixpkgs.system = "x86_64-linux";
  boot.loader.systemd-boot.enable = true;


  imports = [
    ../common
    ./hardware.nix
    ./srht.nix
    ./factorio.nix
    ./dl.nix
  ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "root@pas.sh";
      dnsProvider = "cloudflare";
      credentialsFile = "/etc/nixos/secrets/pas.sh-cloudflare-api-token";
    };
  };
}
