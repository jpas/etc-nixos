name: user:
{ ... }: {
  imports = [ <home-manager/nixos> ];
  users.users."${name}" = {
    hashedPassword = (import ../secrets/passwords.nix)."${name}";
    isNormalUser = true;
    createHome = true;
  } // user;
  home-manager.users."${name}" = import (./. + "/${name}-home-configuration.nix");
}
