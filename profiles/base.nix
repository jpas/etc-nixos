{ lib
, config
, pkgs
, ...
}:

with lib;

{
  imports = [
    ../modules/nixos
    ./overlays-compat.nix
  ];

  i18n.defaultLocale = mkDefault "en_CA.UTF-8";
  time.timeZone = mkDefault "America/Regina";

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;

  console.colors = mkDefault config.hole.colors.gruvbox.dark-no-hash.console;

  documentation.dev.enable = mkDefault true;

  environment.systemPackages = attrValues {
    kitty-terminfo = pkgs.kitty.terminfo;
  };

  environment.defaultPackages = mkDefault (attrValues {
    inherit (pkgs)
      neovim
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

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../pkgs/overlay.nix)
    ];
  };
}
