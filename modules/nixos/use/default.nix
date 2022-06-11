{ config, lib, ... }:

let

  # Propagate system hole profiles as defaults for home hole, but we want to
  # come before anything with mkDefault
  mkPropagate = lib.mkOverride ((lib.mkDefault { }).priority - 1);

in

{
  imports = [
    ../../hole
    ./base.nix
    ./bluetooth.nix
    ./cpu.nix
    ./graphical.nix
    ./laptop.nix
    ./sound.nix
  ];

  home-manager.sharedModules = [
    ({ ... }: {
      options = options.hole.use;
      hole.use = mapAttrs mkPropagate config.hole.use;
    })
  ];
}
