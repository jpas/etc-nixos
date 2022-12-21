{ lib, config, pkgs, ... }:

with lib;

let
  colours = config.hole.colours;
in
{
  environment.systemPackages = [ pkgs.tofi ];

  environment.etc."xdg/tofi/config".text = with colours; ''
    font = monospace
    font-size = 10

    prompt-text = "exec: "

    outline-width = 0
    border-width = 0
    padding-top = 3
    padding-bottom = 1
    padding-left = 4
    padding-right = 4

    horizontal = true
    width = 100%
    anchor = bottom
    height = 24

    result-spacing = 12

    text-color = ${fg}
    background-color = ${bg}

    selection-color = ${bright.aqua}
    selection-background = ${bg}
  '';
}
