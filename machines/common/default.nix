{ lib, config, ... }:

with lib;

{
  imports = [
    ./aleph.nix
  ];

  programs.ssh.knownHosts = {
    doko = {
      extraHostNames = [ "doko.o" "doko.lo" "doko.o.pas.sh" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJIDAF9OYkf42d6VB21Md3iP+VaSN0C1lijNoYfpGV9m";
    };
    kado = {
      extraHostNames = [ "kado.o" "kado.lo" "kado.o.pas.sh" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQhgPYR01kB+Vql3cH2pXPeUCW9sXhiQltX5Gfpwfdo";
    };
    kuro = {
      extraHostNames = [ "kuro.o" "kuro.lo" "kuro.o.pas.sh" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWAg8IMKXHkRkGLmhFH4eWfVtS1qbhHP2Vd3B53JtGL";
    };
    naze = {
      extraHostNames = [ "naze.o" "naze.lo" "naze.o.pas.sh" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJONWNtp0yjroR9LRJzEiUj6eWMmFiJ0MHTveY8j/a5M";
    };
    shiro = {
      extraHostNames = [ "shiro.o" "shiro.lo" "shiro.o.pas.sh" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2FZH5elPX+l0DhMtLo+aLVZVx3LCzUAeJ1D+pcH8Y0";
    };
  };
}
