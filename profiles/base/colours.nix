{ lib, config, pkgs, ... }:

with lib;

let
  fmt = f: mapAttrsRecursive (_: c: f c) config.hole.colours;

  gruvbox = rec {
    bg = bg0;
    bg0 = "282828";
    bg1 = "3c3836";
    bg2 = "504945";
    bg3 = "665c54";
    bg4 = "7c6f64";
    bg5 = "928374";

    fg = fg1;
    fg0 = "fbf1c7";
    fg1 = "ebdbb2";
    fg2 = "d5c4a1";
    fg3 = "bdae93";
    fg4 = "a89984";
    fg5 = bg5;

    regular = {
      red = "cc241d";
      green = "98971a";
      yellow = "d79921";
      blue = "458588";
      purple = "b16286";
      aqua = "689d6a";
      orange = "d65d0e";
    };

    bright = {
      red = "fb4934";
      green = "b8bb26";
      yellow = "fabd2f";
      blue = "83a598";
      purple = "d3869b";
      aqua = "8ec07c";
      orange = "fe8019";
    };

    dim = {
      red = "9d0006";
      green = "79740e";
      yellow = "b57614";
      blue = "076678";
      purple = "8f3f71";
      aqua = "427b58";
      orange = "af3a03";
    };

    vt0 = bg;
    vt1 = regular.red;
    vt2 = regular.green;
    vt3 = regular.yellow;
    vt4 = regular.blue;
    vt5 = regular.purple;
    vt6 = regular.aqua;
    vt7 = fg4;

    vt8 = fg5;
    vt9 = bright.red;
    vt10 = bright.green;
    vt11 = bright.yellow;
    vt12 = bright.blue;
    vt13 = bright.purple;
    vt14 = bright.aqua;
    vt15 = fg;
  };
in
{
  options = {
    hole.colours = mkOption
      {
        type = types.anything;
        default = gruvbox;
        apply = a: a // {
          inherit fmt;
        };
      };
  };

  config = {
    console. colors = mkDefault (with config.hole.colours; [
      vt0
      vt1
      vt2
      vt3
      vt4
      vt5
      vt6
      vt7
      vt8
      vt9
      vt10
      vt11
      vt12
      vt13
      vt14
      vt15
    ]);

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
      foot-terminfo = pkgs.foot.terminfo;
      kitty-terminfo = pkgs.kitty.terminfo;
    };
  };
}
