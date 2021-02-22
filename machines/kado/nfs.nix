{ lib, ... }:

with lib;

let
  hosts = {
    kado = "100.116.4.62";
    kuro = "100.65.152.104";
  };

  mkExports = e: ""

  exports = {
  };

in {
  services.nfs = {
    extraConfig = toINI {
      nfsd = {
        vers2 = false;
	vers3 = false;
	"vers4.0" = false;
	"vers4.1" = false;
	"vers4.2" = true;
      };

      mountd = {
        manage-gids = true;
      };
    };

    server = {
      enable = true;
      exports = mkExports exports;
    };
  };

  {
    enable = true;

    extraNfsdConfig = ''
      host = ${hosts.kado}
      vers2 = no
      vers3 = no
      vers4.0 = no
      vers4.1 = no
    '';

    exports = let
      kuro = "100.116.4.62";
      mounts = {
        "/export" = {
	  allowedIPs = [ kuro ];
	  options = [
	    "rw"
	    "fsid=0"
	    "no_subtree_check"
	  ];
         };
      };
    in ''
    ''
  };
}
