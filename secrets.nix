let lib = (builtins.getFlake "nixpkgs").lib;

in with lib;

let
  meta = fromTOML (readFile ./meta.toml);

  inherit (meta) users machines;

  wheel = filterAttrs (_: user: elem "wheel" (user.groups or [ ])) users;

  publicKeysFor = attrs:
    pipe attrs [
      attrValues
      (map (attrByPath [ "ssh" "publicKeys" ] [ ]))
      concatLists
    ];

  mkSecret = { allow ? { }, ... }@args':
    (removeAttrs args' [ "allow" ]) // {
      publicKeys = (publicKeysFor (allow // wheel))
      ++ (args'.publicKeys or [ ]);
    };

  mkSecrets = args: paths: genAttrs paths (_: mkSecret args);

in
foldl recursiveUpdate { } [
  (mkSecrets { allow = { inherit (machines) doko; }; } [
    "machines/doko/secrets/acme-credentials.age"
    "machines/doko/secrets/authelia-identity-provider-oidc-hmac-secret.age"
    "machines/doko/secrets/authelia-identity-provider-oidc-issuer-private-key.age"
    "machines/doko/secrets/authelia-jwt-secret.age"
    "machines/doko/secrets/authelia-notifier-smtp-password.age"
    "machines/doko/secrets/authelia-storage-encryption-key.age"
    "machines/doko/secrets/authelia-authentication-backend-password.age"
    "machines/doko/secrets/traefik-config.json.age"
    "machines/doko/secrets/lldap-jwt-secret.age"
  ])

  (mkSecrets { allow = { inherit (machines) kuro; }; }
    [ "machines/kado/secrets/torrents-vpn-private-key.age" ])

  (mkSecrets { allow = machines; } [
    "users/root/passwd.age"
    "users/jpas/passwd.age"
    "users/kbell/passwd.age"
  ])
]
