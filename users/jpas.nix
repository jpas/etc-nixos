{ ... }:
{
  users.users.jpas = {
    uid = 1000;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    passwordFile = "/etc/nixos/secrets/passwd.d/jpas";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXyVMHbf69zSybXTmyQc/CHjx7j56O/VAl7N/KsMREw jpas@kuro"
    ];
  };
  home-manager.users.jpas = import ./jpas;
}
