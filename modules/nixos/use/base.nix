{ config, flakes, lib, pkgs, ... }:

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
      programs.neovim = {
        # TODO gruvbox colors by default
        enable = mkDefault true;
        defaultEditor = mkDefault true;
        viAlias = mkDefault true;
        vimAlias = mkDefault true;
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
