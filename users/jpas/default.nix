{ lib
, config
, pkgs
, nixosConfig
, ...
}:

with lib;

{
  imports = [
    ./imv.nix
    ./neovim.nix
    ./sway.nix
    ./tmux.nix
    #./xplr.nix
    ./zathura.nix
  ];

  config = mkMerge [
    {
      home.stateVersion = "22.11";
    }

    {
      programs.git = {
        enable = true;
        lfs.enable = true;
        userName = "Jarrod Pas";
        userEmail = "jarrod@jarrodpas.com";
        extraConfig = {
          pull = { ff = "only"; };
          status = { submodulesummary = 1; };
          submodule = { recurse = true; };
        };
      };
    }

    {
      programs.neovim.enable = true;
    }

    (mkIf nixosConfig.programs.sway.enable {
      wayland.windowManager.sway.enable = true;

      #services.spotifyd.enable = true;
      programs.imv.enable = true;
      programs.kitty.enable = true;
      programs.mako.enable = true;
      programs.mpv.enable = true;
      programs.signal.enable = true;
      programs.zathura.enable = true;

      xdg.mimeApps.enable = true;
    })

    (mkIf config.programs.imv.enable {
      programs.imv = let inherit (nixosConfig.hole) colours; in
        {
          settings = {
            options = {
              background = colours.bg;

              overlay_font = "monospace:14";

              overlay_text_color = colours.fg;
              overlay_text_alpha = "ff";

              overlay_background_color = colours.bg1;
              overlay_background_alpha = "ff";
            };
          };
        };

      wayland.windowManager.sway.config = {
        floating.criteria = [{ app_id = "imv"; }];

        window.commands = [{
          criteria = { app_id = "imv"; };
          command = "border normal";
        }];
      };
    })

    (mkIf config.programs.kitty.enable {
      programs.kitty = let inherit (nixosConfig.hole) colours; in
        {
          font.name = "monospace";

          settings = {
            font_size = 10;

            enable_audio_bell = false;
            visual_bell_duration = 0;

            remember_window_size = false;
            initial_window_width = 800;
            initial_window_height = 600;
            window_padding_width = 3;
            placement_strategy = "center";

            background = colours.bg;
            foreground = colours.fg;

            cursor = colours.fg;
            cursor_text_color = "background";

            color0 = colours.vt0;
            color1 = colours.vt1;
            color2 = colours.vt2;
            color3 = colours.vt3;
            color4 = colours.vt4;
            color5 = colours.vt5;
            color6 = colours.vt6;
            color7 = colours.vt7;

            color8 = colours.vt8;
            color9 = colours.vt9;
            color10 = colours.vt10;
            color11 = colours.vt11;
            color12 = colours.vt12;
            color13 = colours.vt13;
            color14 = colours.vt14;
            color15 = colours.vt15;

            linux_display_server = "auto";
          };
        };
    })
  ];
}
