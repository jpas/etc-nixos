{ lib, ... }:

let
  flakeModule = { flake, pkgs, config, options, ... }: rec {
    _file = ./flakeSystem.nix;
    key = _file;

    config = lib.mkMerge [
      {
        # this may cause infinite recursion...
        nixpkgs.pkgs = flake.legacyPackages.${config.nixpkgs.system};

        system.configurationRevision = lib.mkIf (flake ? rev) flake.rev;
        system.autoUpgrade.flake = flake;

        nix = {
          package = pkgs.nixUnstable;
          extraOptions = lib.mkDefault ''
            experimental-features = ca-references flakes nix-command
          '';
          nixPath = lib.mkDefault [
            "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
            "/nix/var/nix/profiles/per-user/root/channels"
          ];
          registry = {
            system.flake = flake;
            nixpkgs.flake = flake.inputs.nixpkgs;
          };
        };

        home-manager = lib.mkIf (options ? home-manager) {
          useGlobalPkgs = lib.mkForce true;
          useUserPackages = lib.mkForce true;
          sharedModules = lib.attrValues (flake.hmModules or { });
        };

        # FIXME: workaround https://github.com/NixOS/nixpkgs/issues/124215
        documentation.info.enable = lib.mkForce false;
      }

      {
        system.activationScripts =
          let
            channels-flake-compat = pkgs.symlinkJoin {
              name = "channels-flake-compat";
              paths = [
                (pkgs.writeTextDir "nixos/default.nix" ''
                  { ... } @ _: (builtins.getFlake "${flake.outPath}").lib.currentConfiguration.pkgs
                '')
                (pkgs.writeTextDir "nixos/nixos/default.nix" ''
                  { ... } @ _: (builtins.getFlake "${flake.outPath}").lib.currentConfiguration
                '')
              ];
            };
          in
          {
            channels-flake-compat.text = ''
              ln -sfn ${channels-flake-compat} /nix/var/nix/profiles/per-user/root/channels
            '';
          };
      }
    ];
  };

  flakeSystem = { flake, modules, ... } @ args_:
    lib.nixosSystem (builtins.removeAttrs args_ [ "flake" ] // {
      specialArgs = { inherit flake; };
      modules = (args_.modules or [ ])
        ++ [ flakeModule ]
        ++ (lib.attrValues (flake.nixosModules or { }));
    });
in
flakeSystem;
