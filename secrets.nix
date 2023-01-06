let
  concatAttrValues = a: builtins.concatLists (builtins.attrValues a);

  user = {
    jpas = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXyVMHbf69zSybXTmyQc/CHjx7j56O/VAl7N/KsMREw" # jpas@kuro
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID74U4vsKLLwJdb050bv0YzvJ8VYgAkF3kkTmkCOJxvQ" # jpas@shiro
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWZotrVIetC9LgY/KNLteRW/W3noG8+q3ckTyCBwnWE" # jpas@naze
    ];
    kbell = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKYMB+DlGQKxZe0lMCQmYU4yGKHXoNNE9hpGk3NkvyKu" # kbell@shiro
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
    naze = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcO1mSZNIY7N+Or+uRxKjr4TzStWYu7AsrALe3SZ4Jb" ];
    shiro = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2FZH5elPX+l0DhMtLo+aLVZVx3LCzUAeJ1D+pcH8Y0" ];
  };
  systems = concatAttrValues system;

  listToAttrsMap = f: list: builtins.listToAttrs (map f list);

  mkSecrets = listToAttrsMap ({ path, systems ? [ ], users ? [ ] }: {
    name = path;
    value.publicKeys = admins ++ systems ++ users;
  });
in
mkSecrets [
  { path = "machines/doko/.acme-credentials.age"; systems = system.doko; }
  { path = "machines/doko/.authelia-identity-provider-oidc-hmac-secret.age"; systems = system.doko; }
  { path = "machines/doko/.authelia-identity-provider-oidc-issuer-private-key.age"; systems = system.doko; }
  { path = "machines/doko/.authelia-jwt-secret.age"; systems = system.doko; }
  { path = "machines/doko/.authelia-notifier-smtp-password.age"; systems = system.doko; }
  { path = "machines/doko/.authelia-storage-encryption-key.age"; systems = system.doko; }
  { path = "machines/doko/.authelia-authentication-backend-password.age"; systems = system.doko; }
  { path = "machines/doko/.traefik-config.json.age"; systems = system.doko; }
  { path = "machines/doko/.lldap-jwt-secret.age"; systems = system.doko; }
  { path = "machines/doko/.lldap-private-key.age"; systems = system.doko; }
  { path = "machines/kado/.torrents-vpn-private-key.age"; systems = system.kado; }
  { path = "users/jpas/.passwd.age"; systems = systems; }
  { path = "users/kbell/.passwd.age"; systems = systems; }
  { path = "users/root/.passwd.age"; systems = systems; }
]
