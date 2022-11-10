{ lib, ... }:
let
  flakeModule = { flake, pkgs, config, options, ... }: {
    _file = ./flakeSystem.nix;
    key = ./flakeSystem.nix;

    config = {
      nixpkgs.overlays = [ flake.overlays.default ];

      nix = {
        package = pkgs.nixUnstable;
        extraOptions = ''
          experimental-features = flakes nix-command
        '';
        nixPath = lib.mkDefault [
          "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
          "/nix/var/nix/profiles/per-user/root/channels"
        ];
      };

      home-manager = lib.mkIf (options ? home-manager) {
        useGlobalPkgs = lib.mkForce true;
        useUserPackages = lib.mkForce true;
        sharedModules = [ (flake.hmModules.default or { }) ];
      };

      system.configurationRevision = lib.mkIf (flake ? rev) flake.rev;

      system.activationScripts =
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
          flake-channels.text = ''
            ln -sfn ${flake-channels} /nix/var/nix/profiles/per-user/root/channels
          '';
        };

      system.extraSystemBuilderCmds = ''
        ln -s ${flake.outPath} $out/flake
      '';
    };
  };

  flakeSystem = { flake, modules, ... } @ args_:
    lib.nixosSystem (builtins.removeAttrs args_ [ "flake" ] // {
      specialArgs = { inherit flake; };
      modules = (args_.modules or [ ])
        ++ [ flakeModule (flake.nixosModules.default or { }) ];
    });
in
flakeSystem
