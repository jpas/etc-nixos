{ lib
, pkgs
, ...
}:

let
  ftpserver = pkgs.ftpserver;
  configFile = pkgs.writeText "ftpserver.conf"
    (lib.generators.toJSON { } {
      version = 1;
      listen_address = "0.0.0.0:2121";
      passive_transfer_port_range = { start = 2122; end = 2125; };
      logging = {
        file_accesses = true;
      };
      accesses = [
        {
          user = "scanner";
          pass = "scanner"; # TODO: password file?
          fs = "os";
          params = {
            basePath = "/aleph/home/share/scanner";
          };
        }
      ];
    });
in
{
  networking.firewall.allowedTCPPorts = [
    2121
    2122
    2123
    2124
    2125
  ];

  systemd.tmpfiles.rules = [
    "d /aleph/home/share/scanner 2775 root users - -"
  ];

  # ftp server for epson printer to drop files into
  systemd.services.ftpserver = {
    # TODO: do not run as root.
    description = "ftpserver";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Group = "users";
      UMask = "0002";
      ExecStart = "${pkgs.ftpserver}/bin/ftpserver -conf ${configFile}";
      Restart = "always";
    };
  };
}
