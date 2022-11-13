{ lib, nixosConfig, pkgs, ... }:

with lib;

let
  colours = nixosConfig.hole.colours;
in
{
  home.packages = [ pkgs.tofi ];

  home.file.".config/tofi/config".text = with colours; ''
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
