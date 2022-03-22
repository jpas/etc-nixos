{ ... }:
{
  users.users.jpas = {
    uid = 1000;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    passwordFile = "/etc/nixos/secrets/passwd.d/jpas";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+fz+lNCysrW7pTGGq72oVgF7HLF9cnUvPHTYJtmOxG jpas@doko"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXyVMHbf69zSybXTmyQc/CHjx7j56O/VAl7N/KsMREw jpas@kuro"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID74U4vsKLLwJdb050bv0YzvJ8VYgAkF3kkTmkCOJxvQ jpas@shiro"
    ];
  };
  home-manager.users.jpas = import ./jpas;
}
