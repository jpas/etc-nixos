{
  nixpkgs.system = "x86_64-linux";

  networking.hostName = "shiro"; # Define your hostname.

  imports = [
    ../common
    ./hardware.nix
  ];

  hole.profiles = {
    bluetooth = true;
    games = true;
    graphical = true;
  };

  programs.sway.enable = true;

  virtualisation.docker.enable = true;
}
