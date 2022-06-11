{ config, options, lib, ... }:

let

  # Propagate system hole profiles as defaults for home hole, but we want to
  # come before anything with mkDefault
  mkPropagate = lib.mkOverride ((lib.mkDefault { }).priority - 1);

in

{
  imports = [
    ../hole
    #../hole/secrets.nix
  ];

  home-manager.sharedModules = [
    ({ ... }: {
      options = options.hole.profile;
      hole.profile = lib.mapAttrs mkPropagate config.hole.profile;
    })
  ];
}
