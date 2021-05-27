let
  flake = builtins.getFlake "hole";
  hostname = flake.lib.fileContents /etc/hostname;
in
  flake.nixosConfigurations."${hostname}".config.nixpkgs.pkgs
