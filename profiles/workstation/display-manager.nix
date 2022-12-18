{ lib, config, ... }:

with lib;

let
  cfg = config.services.greetd;
in
{
  services.greetd = {
    enable = mkDefault true;

    settings = {
      default_session = {
        command = "${cfg.package}/bin/agreety --cmd 'systemd-cat --identifier=sway sway'";
      };
    };
  };
}
