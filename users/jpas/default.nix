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
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    }

    {
      programs.fzf = {
        enable = true;
        defaultCommand = "fd --type f --follow";
        defaultOptions = [ "--layout=reverse" "--inline-info" "--color=16" ];
      };
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
      xdg.configFile."go/env".text = ''
        GOPATH=$XDG_DATA_HOME/go
        GOMODCACHE=$XDG_CACHE_HOME/go/mod
      '';
    }

    {
      # TODO: import ~/.config/op?
    }

    {
      # TODO: https://doc.rust-lang.org/cargo/guide/cargo-home.html
    }

    {
      # TODO: garbage from electron apps in ~/.config/*
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
      programs.imv = let colors = nixosConfig.hole.colours; in
        {
          settings = {
            options = {
              background = colors.bg;

              overlay_font = "monospace:14";

              overlay_text_color = colors.fg;
              overlay_text_alpha = "ff";

              overlay_background_color = colors.bg1;
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
      programs.kitty = let colors = config.hole.colors.gruvbox.dark; in
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

            background = colors.bg;
            foreground = colors.fg;

            cursor = colors.fg;
            cursor_text_color = "background";

            color0 = elemAt colors.console 0;
            color1 = elemAt colors.console 1;
            color2 = elemAt colors.console 2;
            color3 = elemAt colors.console 3;
            color4 = elemAt colors.console 4;
            color5 = elemAt colors.console 5;
            color6 = elemAt colors.console 6;
            color7 = elemAt colors.console 7;

            color8 = elemAt colors.console 8;
            color9 = elemAt colors.console 9;
            color10 = elemAt colors.console 10;
            color11 = elemAt colors.console 11;
            color12 = elemAt colors.console 12;
            color13 = elemAt colors.console 13;
            color14 = elemAt colors.console 14;
            color15 = elemAt colors.console 15;

            linux_display_server = "auto";
          };
        };
    })

    (mkIf config.programs.mako.enable {
      programs.mako = let colors = config.hole.colors.gruvbox.dark; in
        {
          font = "monospace 10";

          anchor = "bottom-right";

          textColor = colors.fg;
          backgroundColor = colors.bg;
          borderColor = colors.bg2;
          borderSize = 2;

          icons = false;
        };
    })
  ];
}
