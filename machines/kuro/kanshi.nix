{ ... }:

let
  laptop = "Sharp Corporation 0x14CC 0x00000000";
  monitor = "Dell Inc. DELL U2720Q 86CZZ13";
  tv = "Goldstar Company Ltd LG TV 0x00000000";
in
{
  home-manager.sharedModules = [
    ({ ... }: {

      xdg.configFile."kanshi/config".text = ''
        profile docked {
          output "${monitor}" enable position 1920,0
          output "${laptop}" position 0,960
          exec swayutil clamshell-mode "${laptop}"
        }

        profile nomad {
          output "${laptop}" enable position 0,0 transform normal
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
          workspace 1 output "${monitor}"
          workspace 2 output "${monitor}"
          workspace 3 output "${monitor}"
          workspace 4 output "${monitor}"
          workspace 5 output "${monitor}"
          workspace 6 output "${monitor}"
          workspace 7 output "${monitor}"
          workspace 8 output "${monitor}"
          workspace 9 output "${monitor}"

          bindswitch --reload --locked lid:on  exec swayutil clamshell-mode "${laptop}"
          bindswitch --reload --locked lid:off exec swayutil clamshell-mode "${laptop}"
        '';
      };
    })
  ];
}
