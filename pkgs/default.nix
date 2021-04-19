{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) callPackage;
in
rec {
  volatile = import <nixos-volatile> { inherit (pkgs) config; };

  ftpserver = callPackage ./ftpserver { };

  intel-undervolt = callPackage ./intel-undervolt { };

  scholar = callPackage ./scholar { };

  srvfb = callPackage ./srvfb { };

  xplr = callPackage ./xplr { };

  yofi = callPackage ./yofi { };
}
