{ lib
, config
, ...
}:

with lib;

let
  cfg = config.programs.mako;

  colors = config.hole.colors.gruvbox.dark;
in
{
  programs.mako = {
    font = "monospace 10";

    anchor = "bottom-right";

    textColor = colors.fg;
    backgroundColor = colors.bg;
    borderColor = colors.bg2;
    borderSize = 2;

    icons = false;
  };
}
