{ pkgs
, ...
}:

{
  services.factorio = {
    enable = true;
    openFirewall = true;
    port = 34198;
    requireUserVerification = false;
    extraSettings = {
      require_user_verification = false;
      non_blocking_saving = true;
    };
    admins = [ "ydob0n" ];
    game-password = "dolphins";
  };
}
