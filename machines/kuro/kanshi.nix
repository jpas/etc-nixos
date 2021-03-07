{ pkgs, ... }:

let
  laptop = "Sharp Corporation 0x14CC 0x00000000";
  monitor = "Dell Inc. DELL U2720Q 86CZZ13";
  tv = "Goldstar Company Ltd LG TV 0x00000000";
in
{
  home-manager.imports = [
    ({ pkgs, ... }: {
      xdg.configFile."kanshi/config".text = ''
        profile laptop {
          output "${laptop}" enable scale 2
        }

        profile docked {
          output "${laptop}" disable
          output "${monitor}" enable scale 1
        }

        profile docked+tv {
          output "${laptop}" disable
          output "${monitor}" enable scale 1
          output "${tv}" enable scale 1
        }
      '';
    })
  ];
}
