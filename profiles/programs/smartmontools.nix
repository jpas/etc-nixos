{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.nvme-cli
    pkgs.smartmontools
  ];
}
