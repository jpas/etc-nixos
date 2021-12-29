{
  networking.hostName = "shiro";
  nixpkgs.system = "x86_64-linux";

  imports = [
    ../common
    ./hardware.nix
  ];

  hole.profiles = {
    bluetooth = true;
    games = true;
    graphical = true;
    sound = true;
  };

  programs.sway.enable = true;

  virtualisation.docker.enable = true;
}
