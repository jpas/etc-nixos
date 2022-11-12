{ lib, config, pkgs, ... }:

with lib;

{
  environment.systemPackages = attrValues {
    inherit (pkgs) xdg-user-dirs xdg-utils;
  };

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=system/desktop
    DOWNLOAD=downloads
    TEMPLATES=system/templates
    PUBLICSHARE=system/public
    DOCUMENTS=documents
    MUSIC=media/music
    PICTURES=media/photos
    VIDEOS=media/video
  '';

  xdg.mime = { };

  xdg.portal = {
    enable = mkDefault true;
    extraPortals = with pkgs; [
      # required to get gtk apps to find the correct theme
      xdg-desktop-portal-gtk
    ];

    wlr.enable = mkDefault true;
    #wlr.settings.screencast =
    #  let
    #    clear = "00000000";
    #    selected = "${config.hole.colors.gruvbox.dark-no-hash.aqua0}7f";
    #    cmd = concatStringsSep " " [
    #      "${pkgs.slurp}/bin/slurp -or"
    #      "-f %o"
    #      "-B ${clear}"
    #      "-b ${clear}"
    #      "-s ${selected}"
    #      "-w 0"
    #    ];
    #  in
    #  {
    #    chooser_type = mkDefault "simple";
    #    chooser_cmd = mkDefault cmd;
    #  };
  };
};
}
