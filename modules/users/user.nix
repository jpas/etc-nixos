name: user:
{ ... }: {
  imports = [ ../services/home-manager.nix ];
  users.users."${name}" = {
    hashedPassword = (import ../../secrets/passwords.nix)."${name}";
    isNormalUser = true;
    createHome = true;
  } // user;
  home-manager.users."${name}" = import (../users + "/${name}/home-configuration.nix");
}
