{ name
, user
, home
}:

{ config, ... }: {
  users.users."${name}" = user // {
    isNormalUser = true;
    hashedPassword = config.hole.secrets.passwd."${name}";
  };

  home-manager.users."${name}" = { ... }: {
    imports = config.home-manager.imports ++ [ home ];
  };
}
