{ pkgs
, ...
}:
{
  home.packages = [
    pkgs.exa
  ];

  programs.bash.shellAliases = {
    ls = "exa";
  };
}
