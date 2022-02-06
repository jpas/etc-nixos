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
    ./bash.nix
    #./users.nix
    #./steam.nix
  ];
}
