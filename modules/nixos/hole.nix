{ lib
, config
, ...
}:

let
  # Propagate system hole as defaults for home hole, but we want to be come
  # before anything with mkDefault
  mkPropagate = lib.mkOverride ((lib.mkDefault { }).priority - 1);
in
{
  imports = [
    ../hole
    #../hole/secrets.nix
  ];

  home-manager.sharedModules = [
    ({ ... }: {
      hole.profiles = mkPropagate config.hole.profiles;
    })
  ];
}
