{
  docker = ./docker.nix;
  hole = ./hole.nix;
  secrets = ./secrets.nix;
  thermald = ./thermald.nix;

  hardware = ./hardware;
  networking = ./networking.nix;

  bluetooth = ./bluetooth.nix;
  wifi = ./wifi.nix;
  laptop = ./laptop.nix;
}
