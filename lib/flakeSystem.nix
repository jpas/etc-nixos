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
        sharedModules = [ (flake.hmModule or { }) ];
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

      system.extraSystemBuilderCmds = ''
        ln -s ${flake.outPath} $out/flake
      '';
    };
  };

  flakeSystem = { flake, modules, ... } @ args_:
    lib.nixosSystem (builtins.removeAttrs args_ [ "flake" ] // {
      specialArgs = { inherit flake; };
      modules = (args_.modules or [ ])
        ++ [ flakeModule (flake.nixosModule or { }) ];
    });
in
flakeSystem
