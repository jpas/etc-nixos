{ config, flake, lib, pkgs, ... }:

with lib;

let

  cfg = config.hole.use;

in

{
  options = {
    hole.use = {
      base = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable base config.";
      };
      minimal = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable minimal config.";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.base {
      time.timeZone = mkDefault "America/Toronto";
      i18n.defaultLocale = mkDefault "en_CA.UTF-8";

      console = {
        colors = mkDefault config.hole.colors.gruvbox.dark-no-hash.console;
        useXkbConfig = mkDefault true;
      };
      # Does not enable xserver, but make sure the keymap is in sync
      services.xserver.layout = mkDefault "us";

      users = {
        mutableUsers = false;
        users.root.passwordFile = "/etc/nixos/secrets/passwd.d/root";
      };

      environment.etc.inputrc.text = ''
        ${builtins.readFile "${flake.inputs.nixpkgs.outPath}/nixos/modules/programs/bash/inputrc"}
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

      programs.neovim = {
        # TODO gruvbox colors by default
        enable = mkDefault true;
        defaultEditor = mkDefault true;
        viAlias = mkDefault true;
        vimAlias = mkDefault true;
      };

      nix = {
        optimise.automatic = mkDefault true;

        gc = {
          automatic = mkDefault true;
          dates = mkDefault "weekly";
          options = mkDefault "--delete-older-than 30d";
        };

        settings = {
          trusted-users = [ "root" "@wheel" ];
          allowed-users = [ "users" ];
        };
      };

      nixpkgs.config.allowUnfree = true;

      boot.tmpOnTmpfs = mkDefault true;
      boot.kernelPackages = mkDefault (pkgs.linuxPackagesFor pkgs.linux_latest);
      boot.loader =
        let
          common = {
            configurationLimit = mkDefault 10;
          };
        in
        {
          timeout = mkDefault 1;
          grub = common;
          systemd-boot = common;
          generic-extlinux-compatible = common;
        };
    })

    (mkIf (!cfg.minimal && cfg.base) {
      documentation.dev.enable = mkDefault true;

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
      };

      environment.shellAliases = {
        cat = "bat --theme=gruvbox-dark";
        ls = "exa --git";
      };
    })
  ];
}
