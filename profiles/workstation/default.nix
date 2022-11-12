{ lib, config, pkgs, ... }:

with lib;

{
  imports = [ ../base ];

  documentation.dev.enable = mkDefault true;

  environment.systemPackages = attrValues {
    inherit (pkgs)
      nix-diff
      nix-tree
      nixpkgs-fmt
      ;
  };
}
