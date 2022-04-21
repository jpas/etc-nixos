{ lib
, config
, ...
}:

with lib;

{
  imports = [
    ../../users
    ../../profiles
    ./aleph.nix
    ./network.nix
    ./nfs.nix
    ./ssh.nix
    #./users.nix
    #./steam.nix
  ];
}
