{ lib
, config
, ...
}:

with lib;

{
  imports = [
    ../../profiles
    ./aleph.nix
    ./network.nix
    ./nfs.nix
    ./ssh.nix
    #./users.nix
    #./steam.nix
  ];
}
