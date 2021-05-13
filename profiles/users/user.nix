{ name
, user
, home
}:

{ config, ... }: {
  users.users."${name}" = user // {
    isNormalUser = true;
    passwordFile = "/etc/nixos/secrets/passwd.d/${name}";
  };

  home-manager.users."${name}" = { ... }: {
    imports = config.home-manager.imports ++ [ home ];
  };
}
