{ name, user, home }:

{ config, ... }: {
  users.users."${name}" = user // {
    isNormalUser = true;
    hashedPassword = (import ../../secrets/passwords.nix)."${name}";
  };

  home-manager.users."${name}" = { ... }: {
    imports = config.home-manager.imports ++ [ home ];
  };
}
