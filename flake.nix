{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs = {
      url = "github:vlaci/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      inherit (self) lib;

      pkgsFor = lib.genAttrs (lib.attrNames nixpkgs.legacyPackages)
        (system: import nixpkgs {
          inherit system;
          overlays = lib.attrValues self.overlays;
          config = {
            allowUnfree = true;
          };
        });

      mkSystem = base: lib.nixosSystem rec {
        # XXX: system extraction relies on base configuration being an attrset
        system = (import base).nixpkgs.system;
        modules = [
          base

          ({ ... }: {
            imports = [ self.inputs.home-manager.nixosModules.home-manager ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = lib.attrValues self.hmModules;
            };
          })

          ({ pkgs, ... }: {
            system.configurationRevision = lib.mkIf (self ? rev) self.rev;

            imports = lib.attrValues self.nixosModules;

            nix = {
              package = pkgs.nixUnstable;
              extraOptions = ''
                experimental-features = ca-references flakes nix-command
              '';
              nixPath = [
                "nixpkgs=/run/current-system/flake/nixpkgs"
                "nixpkgs-overlays=/run/current-system/flake/hole/lib/compat/overlays"
              ];
              registry = {
                hole.flake = self;
                nixpkgs.flake = nixpkgs;
              };
            };

            system.extraSystemBuilderCmds = ''
              mkdir $out/flake
              ln -s '${self.outPath}' "$out/flake/hole"
              ln -s '${nixpkgs.outPath}' "$out/flake/nixpkgs"
            '';

            system.userActivationScripts = {
              force-nix-defexpr.text = ''
                link_name=$HOME/.nix-defexpr
                target=/run/current-system/flake/hole/lib/compat/nix-defexpr.nix
                if [[ (-e "$link_name") -a (! -h "$link_name") ]]; then
                  mv -f "$link_name" "$link_name".backup
                fi
                ln -sfn "$target" "$link_name"
              '';
            };

            nixpkgs = rec {
              pkgs = pkgsFor.${system};
              inherit (pkgs) config;
            };
          })

          ({ lib, pkgs, ... }: {
            # FIXME: workaround https://github.com/NixOS/nixpkgs/issues/124215
            documentation.info.enable = lib.mkForce false;
          })
        ];
      };

      importDir = dir:
        lib.mapAttrs
          (subdir: _: dir + "/${subdir}")
          (lib.filterAttrs (_: t: t == "directory") (builtins.readDir dir));

    in
    {
      lib = nixpkgs.lib.extend (import ./lib);

      nixosConfigurations = lib.mapAttrs (_: mkSystem) (import ./machines);

      overlays = {
        hole = import ./pkgs;
      };

      hmModules = (import ./modules/home);
      nixosModules = (import ./modules/nixos);

      packages = lib.mapAttrs (_: pkgs: pkgs.hole) pkgsFor;
    };
}
