{ pkgs
, ...
}:

{
  services.factorio = {
    package = pkgs.volatile.factorio-headless;
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
