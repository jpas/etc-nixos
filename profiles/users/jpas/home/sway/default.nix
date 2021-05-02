{ lib
, config
, pkgs
, ...
}:

with lib;

let
  colors = config.hole.colors.gruvbox;

  mkStartupCommand = { command, always ? false, packages ? [ ] }: {
    home.packages = packages;
    wayland.windowManager.sway.config.startup = [{
      inherit command always;
    }];
  };
in
{
  imports = [ ../sway.nix ];

  config = mkMerge [
  ];
}
