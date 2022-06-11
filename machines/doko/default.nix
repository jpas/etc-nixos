{ lib
, pkgs
, ...
}:

{
  networking.hostName = "doko";
  nixpkgs.system = "x86_64-linux";

  hole.use.intel-cpu = true;

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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11"; # Did you read the comment?
}
