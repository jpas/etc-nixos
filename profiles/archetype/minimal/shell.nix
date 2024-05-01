{ lib, inputs, pkgs, ... }:

with lib;

{
  environment.etc.inputrc.text = ''
    ${builtins.readFile "${inputs.nixpkgs.outPath}/nixos/modules/programs/bash/inputrc"}
    # inputrc from configuration.nix

    set editing-mode vi
  '';

  environment.shellAliases = {
    cat = "bat --theme=gruvbox-dark";
    l = "ls -l";
    la = "ls -la";
    ll = "ls -l";
    ls = "eza --git";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  environment.systemPackages = attrValues {
    inherit (pkgs)
      bat
      coreutils
      curl
      dig
      eza
      fd
      file
      git
      jq
      less
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
      wget
      ;
  };

  programs = {
    iotop.enable = true;
    iftop.enable = true;

    bash = {
      promptInit = ''
        ${readFile ./shell-prompt.bash}
      '';

      interactiveShellInit = ''
        HISTFILE="$${XDG_STATE_DIR:-$$HOME/.local/state}/bash_history"
        HISTCONTROL=ignorespace:erasedups
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
  };
}
