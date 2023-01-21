{ lib, flakes, pkgs, ... }:

with lib;

{
  environment.etc.inputrc.text = ''
    ${builtins.readFile "${flakes.nixpkgs.outPath}/nixos/modules/programs/bash/inputrc"}
    # inputrc from configuration.nix

    set editing-mode vi
  '';

  environment.shellAliases = {
    cat = "bat --theme=gruvbox-dark";
    l = "ls -l";
    la = "ls -la";
    ll = "ls -l";
    ls = "exa --git";
  };

  programs.direnv.enable = true;

  environment.systemPackages = attrValues {
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

  programs = {
    iotop.enable = true;
    iftop.enable = true;

    bash = {
      shellInit = ''
        unset HISTFILE
      '';

      promptInit = ''
        ${readFile ./shell-prompt.bash}
      '';
    };

    htop = {
      enable = mkDefault true;
      settings = {
        tree_view = true;
        show_program_path = false;
        hide_kernel_threads = true;
        hide_userland_threads = true;
        show_cpu_frequency = true;
      };
    };

    less = {
      enable = mkDefault true;
      envVariables = {
        LESSHIST = mkDefault "/dev/null";
      };
    };
  };
}