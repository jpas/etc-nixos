{ ... }:

{
  programs.gamescope.enable = true;
  programs.gamescope = {
    args = [ "--rt" ];
    capSysNice = true;
  };
}
