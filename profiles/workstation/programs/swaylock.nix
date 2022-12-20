{ lib, config, ... }:

with lib;

let
  colours = config.hole.colours;

  format = cfg: pipe cfg [
    (mapAttrsToList (n: v: if isNull v then n else "${n}=${toString v}"))
    (concatStringsSep "\n")
  ];
in
{
  environment.etc."swaylock/config".text = format (with colours; rec {
    key-hl-color = fg;
    caps-lock-key-hl-color = ring-color;

    bs-hl-color = neutral.orange;
    caps-lock-bs-hl-color = bs-hl-color;

    font = "monospace";
    font-size = 10;
    color = bg;

    hide-keyboard-layout = null;
    indicator-caps-lock = null;
    disable-caps-lock-text = null;

    ring-color = bg;
    ring-caps-lock-color = key-hl-color;
    ring-clear-color = bs-hl-color;
    ring-ver-color = neutral.blue;
    ring-wrong-color = neutral.red;

    inside-color = "00000000";
    inside-caps-lock-color = inside-color;
    inside-caps-ver-color = inside-color;
    inside-clear-color = inside-color;
    inside-wrong-color = inside-color;

    line-color = "00000000";
    line-caps-lock-color = line-color;
    line-caps-ver-color = line-color;
    line-clear-color = line-color;
    line-wrong-color = line-color;

    text-color = "00000000";
    text-caps-lock-color = text-color;
    text-caps-ver-color = text-color;
    text-clear-color = text-color;
    text-wrong-color = text-color;
  });
}

