{ lib, ... }:

with lib;

{
  programs.go = {
    goPath = lib.mkDefault ".local/share/go";
  };
}
