{
  networking.hostName = "shiro";
  nixpkgs.system = "x86_64-linux";

  imports = [
    ../common
    ./hardware.nix
  ];

  hole.profiles = {
    bluetooth = true;
    desktop = true;
    sound = true;
  };

  programs.sway.enable = true;
}
