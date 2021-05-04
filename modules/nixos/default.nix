{ ... }:
{
  imports = [
    ../hole/nixos
    ./home-manager.nix
    ./services/docker.nix
    ./services/intel-undervolt.nix
    ./services/thermald.nix
    ./services/iwd.nix
    ./xdg-desktop-portal-wlr.nix
  ];
}
