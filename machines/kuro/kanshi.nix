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
          output "${laptop}"  enable  scale 2 position 0,0
        }

        profile docked {
          output "${laptop}"  disable scale 2 position 0,2160
          output "${monitor}" enable  scale 1 position 1920,0
          exec pactl set-card-profile 43 output:hdmi-stereo-extra3+input:analog-stereo
        }

        profile docked+tv {
          output "${laptop}"  disable scale 2 position 0,2160
          output "${monitor}" enable  scale 1 position 1920,0
          output "${tv}"      enable  scale 1 position 1920,2160
          exec pactl set-card-profile 43 output:hdmi-stereo-extra3+input:analog-stereo
        }
      '';
    })
  ];
}
