{ lib, config, flakes, pkgs, ... }:

with lib;

{
  imports = [
    ./agenix.nix
    ./bluetooth.nix
    ./flakes.nix
    ./home-manager.nix
    ./networking
    ./nix.nix
    ./users.nix
  ];

  boot.kernelPackages = mkDefault (pkgs.linuxPackagesFor pkgs.linux_latest);
  boot.tmpOnTmpfs = mkDefault true;
  boot.loader =
    let
      common = { configurationLimit = mkDefault 10; };
    in
    {
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

  programs.neovim = {
    # TODO gruvbox colors by default
    enable = mkDefault true;
    defaultEditor = mkDefault true;
    viAlias = mkDefault true;
    vimAlias = mkDefault true;
  };

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  environment.systemPackages = attrValues {
    kitty-terminfo = pkgs.kitty.terminfo;
    inherit (pkgs)
      bat
      coreutils
      dig curl wget
      exa
      fd
      file
      jq
      lsof
      p7zip
      pciutils
      rclone
      restic
      ripgrep
      rsync
      strace
      tmux
      usbutils
      ;
  };

  environment.shellAliases = {
    cat = "bat --theme=gruvbox-dark";
    l = "ls -l";
    la = "ls -la";
    ll = "ls -l";
    ls = "exa --git";
  };

  programs = {
    iotop.enable = true;
    iftop.enable = true;
  };
}
