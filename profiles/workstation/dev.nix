{ lib, pkgs, ... }:

with lib;

{
  documentation.dev.enable = mkDefault true;

  environment.systemPackages = attrValues {
    inherit (pkgs)
      git
      nixpkgs-fmt
      ;
  };
}
