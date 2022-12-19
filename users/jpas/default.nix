{ lib, ... }:

with lib;

let
  name = "Jarrod Pas";
  email = "jarrod@jarrodpas.com";
in
{
  imports = [ ./email.nix ];

  programs.git.enable = true;
  programs.git = {
    userName = name;
    userEmail = email;

    lfs.enable = true;
    extraConfig = {
      pull.rebase = "true";
      pull.ff = "only";
      submodule.recurse = true;
      status.submodulesummary = 1;
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "22.11";
}
