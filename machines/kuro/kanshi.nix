{ ... }:

let
  laptop = "Sharp Corporation 0x14CC 0x00000000";
  monitor = "Dell Inc. DELL U2720Q 86CZZ13";
  tv = "Goldstar Company Ltd LG TV 0x00000000";
in
{
  home-manager.imports = [
    ({ pkgs, ... }: {
      wayland.windowManager.sway = {
        extraConfig = ''
          bindswitch --locked lid:on  output '${laptop}' disable
          bindswitch --locked lid:off output '${laptop}' enable
          exec_always 'grep -q closed /proc/acpi/button/lid/LID0/state && swaymsg output "${laptop}" disable || swaymsg output "${laptop}" enable'
        '';
        # TODO: fix clamshell toggle on reload
      };

      xdg.configFile."kanshi/config".text = ''
        profile laptop {
          output "${laptop}" scale 2
        }

        profile docked {
          output "${laptop}" scale 2
          output "${monitor}" scale 1
        }

        profile docked+tv {
          output "${laptop}" scale 2
          output "${monitor}" scale 1
          output "${tv}" scale 1
        }
      '';
    })
  ];
}
