{ lib
, ...
}:

with lib;

let
  mkUser = { name, uid, home-config ? { }, ... }:
    { config, ... }: {
      users.users."${name}" = {
        inherit uid;
        isNormalUser = true;
        hashedPassword = config.hole.secrets.passwd."${name}";
      };

      home-manager.users."${name}" = { ... }: {
        imports = config.home-manager.imports ++ [ home-config ];
      };
    };
in
mkMerge [
  (mkUser {
    name = "jpas";
    uid = 1000;
  })

  (mkUser {
    name = "kbell";
    uid = 1001;
  })
]
