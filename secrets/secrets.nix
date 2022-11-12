let
  concatAttrValues = a: builtins.concatLists (builtins.attrValues a);

  user = {
    jpas = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXyVMHbf69zSybXTmyQc/CHjx7j56O/VAl7N/KsMREw" # jpas@kuro
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID74U4vsKLLwJdb050bv0YzvJ8VYgAkF3kkTmkCOJxvQ" # jpas@shiro
    ];
  };
  users = concatAttrValues user;

  admin = {
    inherit (user) jpas;
  };
  admins = concatAttrValues admin;

  system = {
    doko = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJIDAF9OYkf42d6VB21Md3iP+VaSN0C1lijNoYfpGV9m" ];
    kado = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQhgPYR01kB+Vql3cH2pXPeUCW9sXhiQltX5Gfpwfdo" ];
    kuro = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPWAg8IMKXHkRkGLmhFH4eWfVtS1qbhHP2Vd3B53JtGL" ];
    shiro = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2FZH5elPX+l0DhMtLo+aLVZVx3LCzUAeJ1D+pcH8Y0" ];
  };
  systems = concatAttrValues system;
in
{
  "passwd-root.age".publicKeys = admins ++ systems;
  "passwd-jpas.age".publicKeys = admins ++ systems;
  "passwd-kbell.age".publicKeys = admins ++ systems;

  "cloudflare-acme-pas.sh.age".publicKeys = admins ++ system.doko;
}
