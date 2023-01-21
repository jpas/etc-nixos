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

in foldl recursiveUpdate { } [
  (mkSecrets { allow = { inherit (machines) doko; }; } [
    "machines/doko/.acme-credentials.age"
    "machines/doko/.authelia-identity-provider-oidc-hmac-secret.age"
    "machines/doko/.authelia-identity-provider-oidc-issuer-private-key.age"
    "machines/doko/.authelia-jwt-secret.age"
    "machines/doko/.authelia-notifier-smtp-password.age"
    "machines/doko/.authelia-storage-encryption-key.age"
    "machines/doko/.authelia-authentication-backend-password.age"
    "machines/doko/.traefik-config.json.age"
    "machines/doko/.lldap-jwt-secret.age"
  ])

  (mkSecrets { allow = { inherit (machines) kuro; }; }
    [ "machines/kado/.torrents-vpn-private-key.age" ])

  (mkSecrets { allow = machines; } [
    "users/root/.passwd.age"
    "users/jpas/.passwd.age"
    "users/kbell/.passwd.age"
  ])
]
