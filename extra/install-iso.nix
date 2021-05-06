{ lib
, pkgs
, ...
}:

with lib;

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = attrValues {
    inherit (pkgs)
      curl
      exa
      htop
      manpages
      nix-output-monitor
      tmux
      wget
      ;
    kitty-terminfo = pkgs.kitty.terminfo;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
