{ lib, config, ... }:

with lib;

let
  mkUser { name, ... } @ args: {
    users.mutableUsers = false;

    users.users."${name}" = args // {
      passwordFile = config.age.secrets."passwd-${name}".path;
    };
    age.secrets."passwd-name".file = ./. + "${name}/passwd.age";

    home-manager.users."${name}" = import (./. + "${name}") or { };
  };

  mkUsers = flip mapAttrs (name: args: mkUser (args // { inherit name; }));
in
mkUsers {
  root = {
    openssh.authorizedKeys.keys = config.users.users.jpas.openssh.authorizedKeys.keys;
  };

  jpas = {
    uid = 1000;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+fz+lNCysrW7pTGGq72oVgF7HLF9cnUvPHTYJtmOxG jpas@doko"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXyVMHbf69zSybXTmyQc/CHjx7j56O/VAl7N/KsMREw jpas@kuro"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID74U4vsKLLwJdb050bv0YzvJ8VYgAkF3kkTmkCOJxvQ jpas@shiro"
    ];
  };

  kbell = {
    uid = 1001;
    isNormalUser = true;
  };
}
