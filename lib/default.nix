lib: _:
let
  callLibs = file: import file { inherit lib; };
in
{
  flakeSystem = callLibs ./flakeSystem.nix;
}
