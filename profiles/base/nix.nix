{ lib
, config
, ...
}:

with lib;

{
  nix = {
    optimise.automatic = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      trusted-users = [ "root" "@wheel" ];
      allowed-users = [ "@users" ];
    };
  };


  nixpkgs.config = {
    allowUnfree = true;
  };
};
