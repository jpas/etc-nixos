{ lib, config, pkgs, ... }:

with lib;

{
  services.kanidm.enableClient = true;

  services.kanidm.clientSettings = {
    uri = "https://idm.pas.sh";
  };

  services.kanidm.enablePam = true;
  services.kanidm.unixSettings = {
    pam_allowed_login_groups = [ "users" ];
    default_shell = "/run/current-system/sw/bin/bash";
    home_alias = "name";
    uid_attr_map = "name";
    gid_attr_map = "name";
  };

  services.openssh.authorizedKeysCommand =
    "/run/wrappers/bin/kanidm_ssh_authorizedkeys %u";

  security.wrappers.kanidm_ssh_authorizedkeys = {
    owner = "root";
    group = "root";
    source = "${pkgs.kanidm}/bin/kanidm_ssh_authorizedkeys";
  };

  security.pam.dag.services = {
    system-auth.account.kanidm = {
      control = "sufficient";
      arguments = [ "ignore_unknown_user" ];
      path = "${pkgs.kanidm}/lib/pam_kanidm.so";
      after = [ "unix" ];
      before = [ "deny" ];
    };

    system-auth.auth.kanidm = {
      control = "sufficient";
      arguments = [ "ignore_unknown_user" ];
      path = "${pkgs.kanidm}/lib/pam_kanidm.so";
      after = [ "unix" ];
      before = [ "deny" ];
    };
  };
}
