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
        local there=$(xplr "$1")
        cd "$there" || cd "$(dirname "$there")"
      }
    '';
  };
}
