{ lib
, config
, pkgs
, ...
}:

with lib;

{
  i18n.defaultLocale = mkDefault "en_CA.UTF-8";

  time.timeZone = mkDefault "America/Toronto";

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  console.colors = mkDefault config.hole.colors.gruvbox.dark-no-hash.console;

  documentation.dev.enable = mkDefault true;

  environment.systemPackages = attrValues {
    kitty-terminfo = pkgs.kitty.terminfo;
  };

  nix.trustedUsers = [ "root" "@wheel" ];
  nix.allowedUsers = [ "@users" ];

  nixpkgs.config = lib.mkDefault {
    allowUnfree = true;
  };

  environment.defaultPackages = mkDefault (attrValues {
    inherit (pkgs)
      curl
      htop
      manpages
      nix-output-monitor
      rsync
      strace
      tmux
      wget
      ;
  });

  programs.neovim = {
    # TODO gruvbox colors by default
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
