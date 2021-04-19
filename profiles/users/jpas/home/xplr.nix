{ pkgs
, ...
}:
{
  home.packages = [ pkgs.xplr ];

  programs.bash = {
    shellAliases = {
      "x" = "xplr";
    };

    initExtra = ''
      xd() {
        local there=$(xplr)
        cd "$there" || cd "$(dirname "$there")"
      }
    '';
  };
}
