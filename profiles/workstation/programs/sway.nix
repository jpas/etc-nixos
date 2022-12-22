{ lib, config, pkgs, ... }:

with lib;

let
  colours = config.hole.colours.fmt (c: "#${c}");
  colourVariables = with colours; ''
    set {
      $bg ${bg}
      $fg ${fg}

      $bg0 ${bg0}
      $bg1 ${bg1}
      $bg2 ${bg2}
      $bg3 ${bg3}
      $bg4 ${bg4}

      $gray ${gray}

      $fg0 ${fg0}
      $fg1 ${fg1}
      $fg2 ${fg2}
      $fg3 ${fg3}
      $fg4 ${fg4}

      $bright_red    ${bright.red}
      $bright_green  ${bright.green}
      $bright_yellow ${bright.yellow}
      $bright_blue   ${bright.blue}
      $bright_purple ${bright.purple}
      $bright_aqua   ${bright.aqua}
      $bright_orange ${bright.orange}

      $neutral_red    ${neutral.red}
      $neutral_green  ${neutral.green}
      $neutral_yellow ${neutral.yellow}
      $neutral_blue   ${neutral.blue}
      $neutral_purple ${neutral.purple}
      $neutral_aqua   ${neutral.aqua}
      $neutral_orange ${neutral.orange}

      $faded_red      ${faded.red}
      $faded_green    ${faded.green}
      $faded_yellow   ${faded.yellow}
      $faded_blue     ${faded.blue}
      $faded_purple   ${faded.purple}
      $faded_aqua     ${faded.aqua}
      $faded_orange   ${faded.orange}
    }
  '';
in
{
  programs.sway.settings = ''
    # see `man 5 sway` for specifics

    set {
      $mod Mod4
      $font pango:monospace 10
      $terminal kitty
    }

    input type:keyboard xkb_options caps:escape
    input type:touchpad tap enabled

    output * bg ${./swaybg.png} fill

    floating_modifier $mod

    mouse_warping output

    focus_wrapping no
    focus_follows_mouse no
    focus_on_window_activation none

    workspace_layout default
    workspace_auto_back_and_forth yes

    bindsym {
      $mod+Return      exec $terminal
      $mod+d           exec "tofi-run | xargs --no-run-if-empty -- swaymsg exec --"

      $mod+Print       exec grimshot copy area
      $mod+Shift+Print exec grimshot save area

      $mod+Shift+c reload
      $mod+Shift+q kill

      $mod+f           fullscreen toggle
      $mod+space       focus mode_toggle
      $mod+Shift+space floating toggle

      $mod+a focus parent
      $mod+Shift+a focus child

      $mod+h focus left
      $mod+j focus down
      $mod+k focus up
      $mod+l focus right

      $mod+Down  focus down
      $mod+Left  focus left
      $mod+Right focus right
      $mod+Up    focus up

      $mod+1 workspace number 1
      $mod+2 workspace number 2
      $mod+3 workspace number 3
      $mod+4 workspace number 4
      $mod+5 workspace number 5
      $mod+6 workspace number 6
      $mod+7 workspace number 7
      $mod+8 workspace number 8
      $mod+9 workspace number 9

      $mod+Shift+h move left
      $mod+Shift+j move down
      $mod+Shift+k move up
      $mod+Shift+l move right

      $mod+Shift+Down  move down
      $mod+Shift+Left  move left
      $mod+Shift+Right move right
      $mod+Shift+Up    move up

      $mod+Shift+1 move container to workspace number 1
      $mod+Shift+2 move container to workspace number 2
      $mod+Shift+3 move container to workspace number 3
      $mod+Shift+4 move container to workspace number 4
      $mod+Shift+5 move container to workspace number 5
      $mod+Shift+6 move container to workspace number 6
      $mod+Shift+7 move container to workspace number 7
      $mod+Shift+8 move container to workspace number 8
      $mod+Shift+9 move container to workspace number 9

      $mod+minus scratchpad show
      $mod+Shift+minus move scratchpad

      $mod+e       layout toggle split
      $mod+t       layout toggle split tabbed stacking
      $mod+Shift+t layout toggle stacking tabbed split
      $mod+v       splitt
    }

    bindsym --locked {
      XF86AudioMute              exec pulsemixer --toggle-mute
      XF86AudioLowerVolume       exec pulsemixer --change-volume -5
      XF86AudioRaiseVolume       exec pulsemixer --change-volume +5
      Shift+XF86AudioLowerVolume exec pulsemixer --change-volume -1
      Shift+XF86AudioRaiseVolume exec pulsemixer --change-volume +1
    }

    bindsym --locked {
      XF86AudioNext         exec playerctl next
      XF86AudioPlay         exec playerctl play-pause
      XF86AudioPrev         exec playerctl previous
      XF86MonBrightnessDown exec brightnessctl set 5%-
      XF86MonBrightnessUp   exec brightnessctl set 5%+
    }

    set $exit_menu "[l]ock [s]uspend [e]xit [r]eboot [p]oweroff"

    bindsym $mod+Escape \
      bar main colors binding_mode $bg $bg $bright_orange, \
      mode $exit_menu

    mode $exit_menu bindsym {
      e           mode default, exec sway-logout
      l           mode default, exec loginctl lock-session
      p           mode default, exec systemctl poweroff --full
      r           mode default, exec systemctl reboot --full
      s           mode default, exec systemctl suspend --full
      Escape      mode default
      $mod+Escape mode default
    }

    bindsym --locked $mod+Escape exec systemctl suspend --full

    bar main {
      font $font
      separator_symbol "|"
      tray_output primary
      tray_padding 2

      swaybar_command swaybar
      status_command i3blocks
    }

    ${colourVariables}
    default_border normal 2
    default_floating_border normal 2

    client.background        $bg
    client.focused           $bg3        $bg3 $fg  $bright_aqua  $bg3
    client.focused_inactive  $bg2        $bg2 $fg1 $neutral_aqua $bg2
    client.unfocused         $bg1        $bg1 $fg2 $neutral_aqua $bg1
    client.urgent            $bright_red $bg2 $fg1 $neutral_red  $bright_red

    bar main colors {
      background         $bg
      statusline         $fg
      separator          $gray
      focused_workspace  $bg3        $bg3        $fg
      active_workspace   $bg2        $bg2        $fg2
      inactive_workspace $bg1        $bg1        $fg1
      urgent_workspace   $bright_red $bright_red $fg
      binding_mode       $bg         $bg         $fg
    }

    exec_always gammactl set temperature 5000

    for_window [title="."] inhibit_idle fullscreen
    for_window [shell="xwayland"] title_format "[x11] %title%"
    for_window [app_id="Signal"] border pixel, move scratchpad, scratchpad show
  '';

  programs.sway.extraPackages = attrValues {
    inherit (pkgs)
      brightnessctl
      grim
      i3blocks
      kitty
      playerctl
      procps
      pulsemixer
      slurp
      tofi
      wl-clipboard
      ;
  };

  environment.etc."xdg/i3blocks/config".text = ''
    [time]
    command=date '+%m-%d %H:%M'
    interval=1
  '';

  xdg.portal.wlr.enable = mkDefault true;
  #xdg.portal.wlr.settings.screencast = {
  #  chooser_type = mkDefault "simple";
  #  chooser_cmd = mkDefault (with config.hole.colours; concatStringsSep " " [
  #    "${pkgs.slurp}/bin/slurp -or"
  #    "-f %o"
  #    "-b ${bg}00"
  #    "-c ${normal.aqua}ff"
  #    "-s ${normal.aqua}7f"
  #    "-B ${bg}00"
  #    "-w 2"
  #  ]);
  #};
}
