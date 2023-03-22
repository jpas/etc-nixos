{ lib, config, pkgs, ... }:

with lib;

{
  programs._1password-gui = {
    enable = mkDefault true;
    polkitPolicyOwners = pipe config.users.users [
      (filterAttrs (_: u: u.isNormalUser))
      attrNames
    ];
  };
}
