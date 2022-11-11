{ lib, config, flakes, pkgs, ... }:
let
  inherit (flakes) self;

  flake-channels = pkgs.symlinkJoin {
    name = "flake-channels";
    paths = [
      (pkgs.writeTextDir "/nixos/nixos/default.nix" ''
        let
          flake = builtins.getFlake "${self.outPath}";
          hostname = flake.inputs.nixpkgs.lib.fileContents /proc/sys/kernel/hostname;
          eval = flake.nixosConfigurations."''${hostname}";
        in
        { ... }: {
          inherit (eval) pkgs config options;
          system = eval.config.system.build.toplevel;
          inherit (eval.config.system.build) vm vmWithBootLoader;
        }
      '')
      (pkgs.writeTextDir "/nixos/default.nix" ''
        { ... }: (import ./nixos {}).pkgs
      '')
    ];
  };
in
{
  imports = [ self.nixosModules.default or { } ];

  system = {
    configurationRevision = self.rev or "dirty";

    extraSystemBuilderCmds = ''
      ln -s ${self.outPath} $out/flake
    '';

    activationScripts = {
      flake-channels.text = ''
        ln -sfn ${flake-channels} /nix/var/nix/profiles/per-user/root/channels
      '';
    };
  };

  services.getty.greetingLine =
    "<<< Welcome to NixOS ${config.system.nixos.label} @ ${config.system.configurationRevision} - \\l >>>";

  nixpkgs.overlays = [ self.overlays.default or { } ];

  nix = {
    package = pkgs.nixUnstable;
    settings.experimental-features = [ "flakes" "nix-command" ];

    registry = {
      nixpkgs.flake = flakes.nixpkgs;
    };

    # Removes nixos-config from NIX_PATH as there isn't a configuration.nix.
    nixPath = lib.mkOptionDefault [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels/nixos"
    ];
  };
}
