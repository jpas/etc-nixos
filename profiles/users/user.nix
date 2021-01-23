{ name, user, home }:

{ ... }:
{
  users.users."${name}" = user // {
    isNormalUser = true;
    hashedPassword = (import ../../secrets/passwords.nix)."${name}";
  };

  home-manager.users."${name}" = { ... }: {
    imports = [
      ../../modules/home/all-modules.nix
      home
    ];
  };
}
