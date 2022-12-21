{ config, lib, pkgs, modulesPath, ... }:

with lib;

let
  cfg = config.security.pam.dag;

  pamRule = { config, name, ... }: {
    options = {
      name = mkOption {
        readOnly = true;
        default = name;
      };

      control = mkOption {
        type = types.str;
        default = "required";
      };

      path = mkOption {
        type = types.str;
        default = "pam_${name}.so";
      };

      arguments = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      before = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      after = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
    };
  };

  genRules = config: type:
    let
      base = if config.base == null then { } else {
        base = {
          name = "base";
          control = "include";
          path = config.base;
          arguments = [ ];
          before = [ ];
          after = [ ];
        };
      };
      rules = attrValues (config.${type} // base);
      sorted = toposort (a: b: elem b.name a.before || elem a.name b.after) rules;
    in
    forEach sorted.result
      (rule: concatStringsSep " " ([ type rule.control rule.path ] ++ rule.arguments));


  pamService = { config, name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      base = mkOption {
        type = types.nullOr types.str;
        default = null;
      };

      account = mkOption {
        type = with types; attrsOf (submodule pamRule);
        default = { };
      };

      auth = mkOption {
        type = with types; attrsOf (submodule pamRule);
        default = { };
      };

      password = mkOption {
        type = with types; attrsOf (submodule pamRule);
        default = { };
      };

      session = mkOption {
        type = with types; attrsOf (submodule pamRule);
        default = { };
      };

      text = mkOption {
        default = concatStringsSep "\n"
          (flip concatMap [ "account" "auth" "password" "session" ] (genRules config));
      };
    };
  };

in
{
  options.security.pam.dag = {
    services = mkOption {
      type = with types; attrsOf (submodule pamService);
      default = { };
    };
  };

  config = {
    security.pam.services = mapAttrs (_: self: { inherit (self) text; }) cfg.services;

    security.pam.dag.services = {
      other = genAttrs [ "account" "auth" "password" "session" ] (_: {
        deny.control = "required";
        warn.control = "required";
        warn.before = [ "deny" ];
      });

      system-auth = {
        account = {
          unix.control = "sufficient";
          unix.before = [ "deny" ];
          deny.control = "required";
        };
        auth = {
          unix.control = "sufficient";
          unix.arguments = [ "try_first_pass" "nullok" ];
          unix.before = [ "deny" ];
          deny.control = "required";
        };
        password = {
          unix.control = "required";
          unix.arguments = [ "try_first_pass" "nullok" "sha512" "shadow" ];
          unix.before = [ "base" ];
        };
        session = {
          env.control = "required";
          env.arguments = [ "conffile=/etc/pam/environment" "readenv=0" ];
          env.before = [ "unix" ];

          unix.control = "required";
          unix.before = [ "base" ];
        };
      };

      system-login = {
        base = "system-auth";
        account = {
          nologin.control = "required";
          nologin.before = [ "base" ];
        };
        auth = {
          nologin.control = "required";
          nologin.before = [ "base" ];
        };
        session = {
          loginuid.control = "required";
          loginuid.before = [ "base" ];

          lastlog.control = "required";
          lastlog.arguments = [ "silent" ];
          lastlog.before = [ "base" ];

          systemd.control = "optional";
          systemd.path = "${pkgs.systemd}/lib/security/pam_systemd.so";
          systemd.after = [ "base" ];
        };
      };

      system-local-login.base = "system-login";
      system-remote-login.base = "system-login";

      system-service = { };

      login = {
        base = "system-local-login";
        session = {
          lastlog.before = [ "base" ];
        };
      };

      passwd = {
        auth = {
          rootok.control = "sufficient";
          rootok.before = [ "unix" ];
          unix.control = "required";
        };
        account = {
          unix.control = "required";
        };
        password = {
          unix.control = "required";
        };
      };

      chfn.base = "passwd";
      chpasswd.base = "passwd";
      chsh.base = "passwd";
      groupadd.base = "passwd";
      groupdel.base = "passwd";
      groupmod.base = "passwd";
      shadow.base = "passwd";
      useradd.base = "passwd";
      userdel.base = "passwd";
      usermod.base = "passwd";

      swaylock.base = "system-auth";
      sudo.base = "system-auth";

      sshd.base = "system-remote-login";

      su = {
        base = "system-auth";
        auth = {
          rootok.control = "sufficient";
          rootok.before = [ "base" ];
        };
      };

      runuser = {
        auth = {
          rootok.control = "sufficient";
        };
        session = {
          system-login.control = "include";
          system-login.path = "system-login";
        };
      };

      runuser-l = {
        auth = {
          rootok.control = "sufficient";
        };
        session = {
          system-login.control = "include";
          system-login.path = "system-login";
        };
      };

      systemd-user = {
        base = "system-auth";
        session = {
          systemd.control = "optional";
          systemd.path = "${pkgs.systemd}/lib/security/pam_systemd.so";
          systemd.after = [ "base" ];
        };
      };

      polkit-1.base = "system-auth";
    };
  };
}
