{ ... }:
let
  flake = import ../flake-compat.nix;
  hostname = flake.lib.fileContents /etc/hostname;
in
  flake.nixosConfigurations.${hostname}
