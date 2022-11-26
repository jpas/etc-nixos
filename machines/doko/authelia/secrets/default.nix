{
  age.secrets."authelia-notifier-smtp-password" = {
    file = ./secrets/notifier-smtp-password.age;
    owner = "authelia";
  };
  age.secrets."authelia-jwt-secret" = {
    file = ./secrets/jwt-secret.age;
    owner = "authelia";
  };
  age.secrets."authelia-storage-encryption-key" = {
    file = ./secrets/storage-encryption-key.age;
    owner = "authelia";
  };
  age.secrets."authelia-oidc-hmac-secret" = {
    file = ./secrets/oidc-hmac-secret.age;
    owner = "authelia";
  };
  age.secrets."authelia-oidc-issuer-private-key" = {
    file = ./secrets/oidc-issuer-private-key.age;
    owner = "authelia";
  };
}
