{ lib
, config
, ...
}:

with lib;

{
  imports = [
    ./aleph.nix
    ./nfs.nix
  ];
}
