{ lib
, config
, flake
, pkgs
, ...
}:

with lib;

{
  imports = [
    ./networking.nix
    ./boot.nix
    ./nix.nix
  ];

  time.timeZone = mkDefault "America/Toronto";
  i18n.defaultLocale = mkDefault "en_CA.UTF-8";

  console = {
    colors = mkDefault config.hole.colors.gruvbox.dark-no-hash.console;
    useXkbConfig = mkDefault true;
  };
  # Does not enable xserver, but make sure the keymap is in sync
  services.xserver.layout = mkDefault "us";

  documentation.dev.enable = mkDefault true;

  users = {
    mutableUsers = false;
    users.root.passwordFile = "/etc/nixos/secrets/passwd.d/root";
  };

  environment.systemPackages = attrValues {
    inherit (pkgs)
      bat
      coreutils
      curl
      exa
      fd
      file
      p7zip
      pciutils
      restic
      rsync
      jq
      ripgrep
      strace
      tmux
      usbutils
      wget
      ;
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

  programs.bash = {
    shellInit = ''
      unset HISTFILE
    '';

    promptInit = ''
      ${builtins.readFile ./prompt-init.bash}
    '';
  };

  environment.shellAliases = {
    cat = "bat --theme=gruvbox-dark";
    ls = "exa --git";
    la = "ls -la";
    l = "ls -l";
    ll = "ls -l";
  };
  environment.localBinInPath = true;

  environment.etc.inputrc.text = ''
    ${builtins.readFile "${flake.inputs.nixpkgs.outPath}/nixos/modules/programs/bash/inputrc"}
    # inputrc from configuration.nix

    set editing-mode vi
  '';

  programs.neovim = {
    # TODO gruvbox colors by default
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "unstable"; # Did you read the comment?
}
