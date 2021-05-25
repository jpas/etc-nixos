let
  flake = builtins.getFlake "pkgs";
  hostname = flake.inputs.nixpkgs.lib.fileContents /etc/hostname;
in
  flake.nixosConfigurations.${hostname}
