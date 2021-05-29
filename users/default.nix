{ lib
, config
, ...
}:

with lib;

let
  cfg = config.hole.users;

  users = {
    root = { };
    jpas = { uid = 1000; };
    kbell = { uid = 1001; };
  };

  user = types.submodule {
    options = {
      login = mkEnableOption "allow this user to login";
      wheel = mkEnableOption "add this user to the wheel group";

      id = mkOption {
        type = types.int;
      };
    };
  };
in
{
  options.hole = {
    users = types.attrsOf user
  };

  config = {
    users.users = mapAttrs cfg.users
      (name: user: {
        isNormalUser = true;
        inherit (user) uid;
        createHome = user.login;
      })
  };
}
