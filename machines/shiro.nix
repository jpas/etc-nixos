{ ... }:
{
  networking.hostName = "shiro"; # Define your hostname.

  nixpkgs.system = "x86_64-linux";

  imports = [
    ../modules/hardware/logitech-mx-master-3.nix

    ../modules/profiles/graphical.nix

    ../modules/services/systemd-boot.nix
    ../modules/services/games

    ../modules/users/jpas
    ../modules/users/kbell
  ];
}
