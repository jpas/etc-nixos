{ lib, pkgs, ... }:

with lib;

{
  environment.systemPackages = attrValues {
    inherit (pkgs) xdg-user-dirs xdg-utils;
  };

  environment.sessionVariables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  environment.localBinInPath = true;

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

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  systemd.user.services = {
    xdg-user-dirs-update = {
      before = [ "default.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.xdg-user-dirs}/bin/xdg-user-dirs-update";
      };
    };

    xdg-desktop-portal-gtk = {
      partOf = [ "graphical-session.target" ];
      serviceConfig.Slice = "session.slice";
    };

    xdg-permission-store = {
      serviceConfig.Slice = "session.slice";
    };
  };
}
