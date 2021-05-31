{ ... }:
{
  users.users.kbell = {
    uid = 1001;
    isNormalUser = true;
    passwordFile = "/etc/nixos/secrets/passwd.d/kbell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXyVMHbf69zSybXTmyQc/CHjx7j56O/VAl7N/KsMREw jpas@kuro"
    ];
  };
  home-manager.users.kbell = import ./kbell;
}
