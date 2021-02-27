{ lib, config, pkgs, ... }:

with lib;

let

  cfg = config.programs.signal;

in {
  options = {
    programs.signal = {
      enable = mkEnableOption "Signal";

      package = mkOption {
        type = types.package;
        default = pkgs.signal-desktop;
        defaultText = literalExample "pkgs.signal-desktop";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ cfg.package ];

      wayland.windowManager.sway.config = {
        floating.criteria = [{ class = "Signal"; }];
      };
    })
  ];
}
