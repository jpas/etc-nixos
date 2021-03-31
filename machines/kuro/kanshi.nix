{ pkgs, ... }:

let
  laptop = "Sharp Corporation 0x14CC 0x00000000";
  monitor = "Dell Inc. DELL U2720Q 86CZZ13";
  tv = "Goldstar Company Ltd LG TV 0x00000000";
in
{
  home-manager.imports = [
    ({ pkgs, ... }: {
      wayland.windowManager.sway = {
        config = {
          output = {
            "${laptop}" = {
              scale = "2";
              position = "0 2160";
            };

            "${monitor}" = {
              scale = "1";
              position = "1920 0";
            };
          };
        };

        extraConfig = ''
          workspace 1 output "${monitor}" "${laptop}" "${tv}"
          workspace 2 output "${monitor}" "${laptop}" "${tv}"
          workspace 3 output "${monitor}" "${laptop}" "${tv}"
          workspace 4 output "${monitor}" "${laptop}" "${tv}"
          workspace 5 output "${monitor}" "${laptop}" "${tv}"
          workspace 6 output "${monitor}" "${laptop}" "${tv}"
          workspace 7 output "${monitor}" "${laptop}" "${tv}"
          workspace 8 output "${monitor}" "${laptop}" "${tv}"
          workspace 9 output "${monitor}" "${laptop}" "${tv}"

          bindswitch --reload --locked lid:on  exec swayutil clamshell-mode "${laptop}"
          bindswitch --reload --locked lid:off exec swayutil clamshell-mode "${laptop}"
          exec_always swayutil clamshell-mode "${laptop}"
        '';
      };
    })
  ];
}
