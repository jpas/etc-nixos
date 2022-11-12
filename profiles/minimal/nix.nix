{ lib, ... }:

with lib;

{
  nix = {
    optimise.automatic = mkDefault true;

    gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 30d";
    };

    settings = {
      trusted-users = [ "root" "@wheel" ];
      allowed-users = [ "@users" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
