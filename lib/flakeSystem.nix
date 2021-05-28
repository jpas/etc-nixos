{ lib, ... }:
let
  inherit (lib.modules) mkIf mkForce;

  flakeModule = { flake, pkgs, config, options, ... }: {
    _file = ./flakeSystem.nix;
    key = ./flakeSystem.nix;

    config = {
      # FIXME: workaround https://github.com/NixOS/nixpkgs/issues/124215
      documentation.info.enable = lib.mkForce false;

      # XXX: if this is leading to infinite recursion, ensure the option
      # nixpkgs.system is a literal string.
      nixpkgs.pkgs = flake.legacyPackages."${config.nixpkgs.system}";

      nix = {
        package = pkgs.nixUnstable;
        extraOptions = lib.mkOptionDefault ''
          experimental-features = ca-references flakes nix-command
        '';
        nixPath = lib.mkOptionDefault [
          "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
        registry = {
          system.flake = lib.mkForce flake;
          nixpkgs.flake = lib.mkForce flake.inputs.nixpkgs;
        };
      };

      home-manager = lib.mkIf (options ? home-manager) {
        useGlobalPkgs = lib.mkForce true;
        useUserPackages = lib.mkForce true;
        sharedModules = lib.attrValues (flake.hmModules or { });
      };

      system.configurationRevision = lib.mkIf (flake ? rev) flake.rev;
      system.activationScripts =
        let
          configuration = pkgs.writeText "flake-configuration" ''
            let
              flake = builtins.getFlake "${flake.outPath}";
              hostname = flake.inputs.nixpkgs.lib.fileContents /proc/sys/kernel/hostname;
            in
              flake.nixosConfigurations."''${hostname}"
          '';

          flake-channels = pkgs.symlinkJoin {
            name = "flake-channels";
            paths = [
              (pkgs.writeTextDir "nixos/default.nix" ''
                { ... } @ _: (import ${configuration}).pkgs
              '')
              (pkgs.writeTextDir "nixos/nixos/default.nix" ''
                { ... } @ _: (import ${configuration})
              '')
            ];
          };
        in
        {
          flake-channels.text = ''
            ln -sfn ${flake-channels} /nix/var/nix/profiles/per-user/root/channels
          '';
        };
    };
  };

  flakeSystem = { flake, modules, ... } @ args_:
    lib.nixosSystem (builtins.removeAttrs args_ [ "flake" ] // {
      specialArgs = { inherit flake; };
      modules = (args_.modules or [ ])
        ++ [ flakeModule ]
        ++ (lib.attrValues (flake.nixosModules or { }));
    });
in
  flakeSystem
