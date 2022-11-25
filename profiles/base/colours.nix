{ lib, config, pkgs, ... }:

with lib;

let
  mkColour = path: hex: ansi: [
    (setAttrByPath path hex)
    (setAttrByPath [ "ansi" "c${toString ansi}" ] hex)
  ];

  # see: https://github.com/gruvbox-community/gruvbox-contrib/blob/master/color.table
  gruvbox' = foldl recursiveUpdate { } (concatLists [
    (mkColour [ "dark0_hard" ] "1d2021" 234)
    (mkColour [ "dark0" ] "282828" 235)
    (mkColour [ "dark0_soft" ] "32302f" 236)
    (mkColour [ "dark1" ] "3c3836" 237)
    (mkColour [ "dark2" ] "504945" 239)
    (mkColour [ "dark3" ] "665c54" 241)
    (mkColour [ "dark4" ] "7c6f64" 243)

    (mkColour [ "gray_245" ] "928374" 245)
    (mkColour [ "gray_244" ] "928374" 244)

    (mkColour [ "light0_hard" ] "f9f5d7" 230)
    (mkColour [ "light0" ] "fbf1c7" 229)
    (mkColour [ "light0_soft" ] "f2e5bc" 228)
    (mkColour [ "light1" ] "ebdbb2" 223)
    (mkColour [ "light2" ] "d5c4a1" 250)
    (mkColour [ "light3" ] "bdae93" 248)
    (mkColour [ "light4" ] "a89984" 246)

    (mkColour [ "bright" "red" ] "fb4934" 167)
    (mkColour [ "bright" "green" ] "b8bb26" 142)
    (mkColour [ "bright" "yellow" ] "fabd2f" 214)
    (mkColour [ "bright" "blue" ] "83a598" 109)
    (mkColour [ "bright" "purple" ] "d3869b" 175)
    (mkColour [ "bright" "aqua" ] "8ec07c" 108)
    (mkColour [ "bright" "orange" ] "fe8019" 208)

    (mkColour [ "neutral" "red" ] "cc241d" 124)
    (mkColour [ "neutral" "green" ] "98971a" 106)
    (mkColour [ "neutral" "yellow" ] "d79921" 172)
    (mkColour [ "neutral" "blue" ] "458588" 66)
    (mkColour [ "neutral" "purple" ] "b16286" 132)
    (mkColour [ "neutral" "aqua" ] "689d6a" 72)
    (mkColour [ "neutral" "orange" ] "d65d0e" 166)

    (mkColour [ "faded" "red" ] "9d0006" 88)
    (mkColour [ "faded" "green" ] "79740e" 100)
    (mkColour [ "faded" "yellow" ] "b57614" 136)
    (mkColour [ "faded" "blue" ] "076678" 24)
    (mkColour [ "faded" "purple" ] "8f3f71" 96)
    (mkColour [ "faded" "aqua" ] "427b58" 65)
    (mkColour [ "faded" "orange" ] "af3a03" 130)
  ]);

  fmt' = prev: f:
    let self = mapAttrsRecursive (_: v: f v) prev; in self // { fmt = fmt' self; };

  gruvbox-dark = recursiveUpdate gruvbox' (with gruvbox'; rec {
    bg = bg0;
    fg = fg1;

    bg0 = dark0;
    bg1 = dark1;
    bg2 = dark2;
    bg3 = dark3;
    bg4 = dark4;

    gray = gray_245;

    fg0 = light0;
    fg1 = light1;
    fg2 = light2;
    fg3 = light3;
    fg4 = light4;

    ansi = {
      c0 = bg;
      c1 = neutral.red;
      c2 = neutral.green;
      c3 = neutral.yellow;
      c4 = neutral.blue;
      c5 = neutral.purple;
      c6 = neutral.aqua;
      c7 = fg4;

      c8 = gray;
      c9 = bright.red;
      c10 = bright.green;
      c11 = bright.yellow;
      c12 = bright.blue;
      c13 = bright.purple;
      c14 = bright.aqua;
      c15 = fg1;
    };
  });
in
{
  options = {
    hole.colours = mkOption
      {
        type = types.anything;
        default = gruvbox-dark;
        apply = a: fmt' a (x: x);
      };
  };

  config = {
    console. colors = mkDefault
      (map (c: config.hole.colours.ansi."c${toString c}") (range 0 15));

    # fixes truecolor detection through ssh and sudo.
    security.sudo.extraConfig = mkAfter ''
      Defaults env_keep+=COLORTERM
    '';

    services.openssh.extraConfig = mkAfter ''
      AcceptEnv COLORTERM
    '';

    programs.ssh.extraConfig = mkAfter ''
      SendEnv COLORTERM
    '';

    environment.systemPackages = attrValues {
      kitty-terminfo = pkgs.kitty.terminfo;
    };
  };
}
