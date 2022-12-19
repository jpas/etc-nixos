{ lib, config, pkgs, ... }:

with lib;

let
  colours = config.hole.colours;

  wrapper = pkgs.writeShellScriptBin "tofi-wrapper" ''
    exec "${pkgs.tofi}/bin/$(basename "$0")" --include /etc/xdg/tofi/config
  '';
in
{
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "tofi";
      paths = [ pkgs.tofi wrapper ];
      postBuild = ''
        mv $out/bin/tofi-wrapper $out/bin/tofi
      '';
    })
  ];

  environment.etc."xdg/tofi/config".text = with colours; ''
    font = monospace
    font-size = 10

    prompt-text = "exec: "

    outline-width = 0
    border-width = 0
    padding-top = 2
    padding-bottom = 2
    padding-left = 4
    padding-right = 4

    horizontal = true
    width = 100%
    anchor = bottom
    height = 24

    result-spacing = 12

    text-color = ${fg}
    background-color = ${bg}

    selection-color = ${fg}
    selection-background = ${bg2}
  '';
}
