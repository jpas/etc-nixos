{ lib, config, ... }:

with lib;

let

  cfg = config.services.samba;

in mkMerge [
  {
  services.samba = {
    enable = true;

    enableNmbd = false;
    enableWinbindd = false;

    extraConfig = ''
      workgroup = HOLE
      server string = ${config.networking.hostName}
      netbios name = ${config.networking.hostName}
      hosts allow = 10.39. 100. localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      passdb backend = smbpasswd
    '';

    # XXX: you still need to set passwords for each user. Note the contents of
    # the smbpasswd file are essetially the same as having the plaintext
    # password for the purposes of authentication, so they cannot reside inside
    # the nix store. At some point I'd like to figure out a nice way to keep
    # local/smb passwords in sync, but for now I have to manually enter them.
    # smbpasswd -a $USER

    shares = {
      data = {
        path = "/export/aleph";
        browseable = "yes";
        "guest ok" = "no";
        "read only" = "no";
        "create mask" = "0700";
        "directory mask" = "0700";
      };
    };
  };
}

  (mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 445 139 ];
    networking.firewall.allowedUDPPorts = [ 137 138 ];

    # XXX: it  seems like samba doesn't properly set the permissions of
    # /var/lib/samba/private to 700, so we make sure they're correct here

    systemd.services."samba-smbd".preStart = ''
      mkdir -p /var/lib/samba/private
      chmod 700 /var/lib/samba/private
    '';
  })
]
