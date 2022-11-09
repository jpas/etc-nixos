{ config, ... }:
{
  age.secrets.passwd-kbell.file = ../secrets/passwd-kbell.age;
  users.users.kbell.passwordFile = config.age.secrets.passwd-kbell.path;

  users.users.kbell = {
    uid = 1001;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ ];
  };
  #home-manager.users.kbell = import ./kbell;
}
