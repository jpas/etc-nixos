let
  module = { ... }: {
    services.syncthing.enable = true;
  };
in
{
  home-manager.sharedModules = [ module ];
}
