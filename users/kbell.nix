{ ... }:
{
  users.users.kbell = {
    uid = 1001;
    isNormalUser = true;
    passwordFile = "/etc/nixos/secrets/passwd.d/kbell";
  };
  #home-manager.users.kbell = import ./kbell;
}
