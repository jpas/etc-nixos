{ pkgs
, ...
}:

{
  services.factorio = {
    enable = true;
    openFirewall = true;
    requireUserVerification = false;
    extraSettings = {
      require_user_verification = false;
      non_blocking_saving = true;
      admins = [ "ydob0n" ];
    };
  };
}
