{
  age.secrets."authelia-notifier-smtp-password" = {
    file = ./notifier-smtp-password.age;
    owner = "authelia";
  };
  age.secrets."authelia-jwt-secret" = {
    file = ./jwt-secret.age;
    owner = "authelia";
  };
  age.secrets."authelia-storage-encryption-key" = {
    file = ./storage-encryption-key.age;
    owner = "authelia";
  };
  age.secrets."authelia-oidc-hmac-secret" = {
    file = ./oidc-hmac-secret.age;
    owner = "authelia";
  };
  age.secrets."authelia-oidc-issuer-private-key" = {
    file = ./oidc-issuer-private-key.age;
    owner = "authelia";
  };
}
