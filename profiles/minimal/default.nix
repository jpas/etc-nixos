{ lib, config, flakes, pkgs, ... }:

with lib;

{
  imports = [
    ./agenix.nix
    ./flakes.nix
    ./home-manager.nix
    ./networking
    ./nix.nix
    ./users.nix
  ];

  boot.kernelPackages = mkDefault (pkgs.linuxPackagesFor pkgs.linux_latest);
  boot.tmpOnTmpfs = mkDefault true;
  boot.loader = let
    common = { configurationLimit = mkDefault 10; };
  in {
    timeout = mkDefault 1;
    grub = common;
    systemd-boot = common // { editor = false; };
    generic-extlinux-compatible = common;
  };

  time.timeZone = mkDefault "America/Toronto";
  i18n.defaultLocale = mkDefault "en_CA.UTF-8";

  console = {
    colors = mkDefault config.hole.colors.gruvbox.dark-no-hash.console;
    useXkbConfig = mkDefault true;
  };
  # Does not enable xserver, but make sure the keymap is in sync
  services.xserver.layout = mkDefault "us";

  environment.etc.inputrc.text = ''
    ${builtins.readFile "${flakes.nixpkgs.outPath}/nixos/modules/programs/bash/inputrc"}
    # inputrc from configuration.nix

    set editing-mode vi
  '';

  programs.bash = {
    shellInit = ''
      unset HISTFILE
    '';

    promptInit = ''
      ${builtins.readFile ./prompt-init.bash}
    '';
  };

  environment.localBinInPath = true;
  environment.shellAliases = {
    la = "ls -la";
    l = "ls -l";
    ll = "ls -l";
  };

  environment.systemPackages = attrValues {
    kitty-terminfo = pkgs.kitty.terminfo;
  };

  programs.htop = {
    enable = mkDefault true;
    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
    };
  };

  programs.less = {
    enable = mkDefault true;
    envVariables = {
      LESSHIST = mkDefault "/dev/null";
    };
  };

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  environment.systemPackages = attrValues {
    inherit (pkgs)
      bat
      file
      coreutils
      curl
      exa
      fd
      p7zip
      rclone
      restic
      rsync
      jq
      ripgrep
      tmux
      wget
      nixpkgs-fmt
      nix-diff
      nix-tree

      dig

      # linux utilities
      lsof
      strace
      pciutils
      usbutils
      ;
  };

  programs = {
    iotop.enable = true;
    iftop.enable = true;
  };
}
