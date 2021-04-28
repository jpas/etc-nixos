{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) callPackage;
in
rec {
  volatile = import <nixos-volatile> { inherit (pkgs) config; };

  intel-undervolt = callPackage ./intel-undervolt { };
  scholar = callPackage ./scholar { };
  srvfb = callPackage ./srvfb { };
  yofi = callPackage ./yofi { };

  ftpserver = callPackage ./ftpserver { };
}
