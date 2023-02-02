{ lib, config, ... }:

with lib;

let
  # TODO(jpas): remove small moduli for diffie-hellman-group-exchange-sha256
  # awk '$5 > 2000' /etc/ssh/moduli > "${HOME}/moduli"
  # wc -l "${HOME}/moduli" # make sure there is something left
in
{
  services.openssh = {
    enable = mkDefault true;
    settings = {
      PasswordAuthentication = mkDefault false;
      KbdInteractiveAuthentication = mkDefault false;
      AuthenticationMethods = "publickey";
    };
  };

  programs.ssh = {
    # NOTE(jpas): These settings are taken from Mozilla's client configuration
    # recommendations accessed on 2021-03-18.
    # https://infosec.mozilla.org/guidelines/openssh#modern
    extraConfig = ''
      HashKnownHosts yes

      Host *
        PubkeyAuthentication yes
        PasswordAuthentication no
        ChallengeResponseAuthentication no
    '';

    hostKeyAlgorithms = [
      "ssh-ed25519-cert-v01@openssh.com"
      "ssh-rsa-cert-v01@openssh.com"
      "ssh-ed25519"
      "ssh-rsa"
    ];

    inherit (config.services.openssh)
      ciphers
      kexAlgorithms
      macs
      ;
  };
}
