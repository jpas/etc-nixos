{ lib, flake, pkgs, ... }:
let
  flake-channels = pkgs.symlinkJoin {
    name = "flake-channels";
    paths = [
      (pkgs.writeTextDir "/nixos/nixos/default.nix" ''
        let
          flake = builtins.getFlake "${flake.outPath}";
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
  imports = [ flake.nixosModules.default or { }) ];

  nixpkgs.overlays = [ (flake.overlays.default or { }) ];

  system.configurationRevision = flake.rev or "dirty";
  services.getty.greetingLine =
    "<<< Welcome to NixOS ${config.system.nixos.label} @ ${config.system.configurationRevision} - \\l >>>";

  system.extraSystemBuilderCmds = ''
    ln -s ${flake.outPath} $out/flake
  '';

  system.activationScripts = {
    flake-channels.text = ''
      ln -sfn ${flake-channels} /nix/var/nix/profiles/per-user/root/channels
    '';
  };

  nix = {
    package = pkgs.nixUnstable;
    settings.experimental-features = [ "flakes" "nix-command" ];

    registry = {
      nixpkgs.flake = flake.inputs.nixpkgs;
    };

    nixPath = lib.mkOptionDefault [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels/nixos"
    ];
  };
}
