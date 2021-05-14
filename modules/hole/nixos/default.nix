{ lib
, config
, ...
}:
{
  imports = [
    ../.
  ];

  home-manager.sharedModules = [
    ({ ... }: {
      hole.profiles = lib.mkDefault config.hole.profiles;
    })
  ];
}
