{ config, lib, options, ... }:

with lib;

let

  # Propagate system hole.use as defaults for home hole, but we want to
  # come before anything with mkDefault
  mkPropagate = mkOverride ((mkDefault { }).priority - 1);

in

{
  imports = [
    ../../hole
    ./base.nix
    ./cpu.nix
  ];

  home-manager.sharedModules = [
    ({ ... }: {
      options.hole.use = options.hole.use;
      config.hole.use = mapAttrs (_: v: mkPropagate v) config.hole.use;
    })
  ];
}
