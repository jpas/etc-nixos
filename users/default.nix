{ lib, config, ... }:

with lib;

let
  mkUser = name: user: {
    users.mutableUsers = false;

    age.secrets."passwd-${name}".file = ./. + "/${name}/.passwd.age";
    users.users."${name}" = user // {
      passwordFile = config.age.secrets."passwd-${name}".path;
    };

    home-manager.users."${name}" =
      let path = ./. + "/${name}/default.nix"; in mkIf (pathExists path) (import path);
  };

  mkUsers = users: mkMerge (mapAttrsToList mkUser users);
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILZMekygQJMxKhePxDob/tKFwhXDShe7OZ5EnEa6OXWn kbell@DESKTOP-H4OF685-WSL"
    ];
  };
}
