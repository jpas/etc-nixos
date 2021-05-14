{ pkgs, ... }:

let
  laptop = "Sharp Corporation 0x14CC 0x00000000";
  monitor = "Dell Inc. DELL U2720Q 86CZZ13";
  tv = "Goldstar Company Ltd LG TV 0x00000000";
in
{
  home-manager.sharedModules = [
    ({ pkgs, ... }: {

      xdg.configFile."kanshi/config".text = ''
        profile docked {
          output "${monitor}" enable position 0,0
          output "${laptop}" position 3840,2160
          exec swayutil clamshell-mode "${laptop}"
        }

        profile nomad {
          output "${laptop}" enable position 0,0
        }
      '';

      wayland.windowManager.sway = {
        config = {
          output = {
            "${laptop}" = {
              scale = "2";
            };
          };
        };

        extraConfig = ''
          set $primary "${monitor}"
          set $laptop  "${laptop}"

          workspace 1 output ''$primary
          workspace 2 output ''$primary
          workspace 3 output ''$primary
          workspace 4 output ''$primary
          workspace 5 output ''$primary
          workspace 6 output ''$primary
          workspace 7 output ''$primary
          workspace 8 output ''$primary
          workspace 9 output ''$primary

          bindswitch --reload --locked lid:on  exec swayutil clamshell-mode "''$laptop"
          bindswitch --reload --locked lid:off exec swayutil clamshell-mode "''$laptop"
        '';
      };
    })
  ];
}
