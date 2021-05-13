{ ... }:
let
  flake = import ../flake-compat.nix;
  hostname = flake.inputs.nixpkgs.lib.fileContents /etc/hostname;
in
  flake.nixosConfigurations.${hostname}
