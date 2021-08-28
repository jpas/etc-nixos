final: prev:
let
  inherit (prev) lib callPackage;

  hole = rec {
    lib = prev.lib.extend (import ../lib);

    makeOzoneWrapper = { bin, pkg, ... }@args_:
      let
        args = removeAttrs args_ [ "bin" "pkg" ];
        wrapped = final.writeShellScriptBin bin ''
          declare -a args
          if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
            args+=(--enable-features=UseOzonePlatform --ozone-platform=wayland)
          fi
          exec "${pkg}/bin/${bin}" "''${args[@]}" "$@"
        '';
      in
      final.symlinkJoin (args // {
        name = "${pkg.name}-ozone-wrapper";
        paths = [ wrapped pkg ];
      });

    swaynagmode = callPackage ./swaynagmode { };
    ftpserver = callPackage ./ftpserver { };
    gamescope = callPackage ./gamescope { inherit libliftoff; };
    libliftoff = callPackage ./libliftoff { };
    oauth2ms = callPackage ./oauth2ms { };
    oauth2token = callPackage ./oauth2token { };
    trinity = callPackage ./trinity { stdenv = final.clang11Stdenv; };
    xplr = callPackage ./xplr { };

    signal-desktop = makeOzoneWrapper {
      pkg = prev.signal-desktop;
      bin = "signal-desktop";
      postBuild = ''
        rm $out/bin/signal-desktop-unwrapped
      '';
    };

    discord = prev.discord.overrideAttrs (old: {
      installPhase = (old.installPhase or "") + ''
        mv $out/bin/Discord $out/bin/discord
      '';
    });

    kanshi = prev.kanshi.overrideAttrs (_: {
      version = "2021-02-02-unstable";
      src = final.fetchFromGitHub {
        owner = "emersion";
        repo = "kanshi";
        rev = "dabd7a29174a74b3f21a2b4cc3d9dc63221761bb";
        hash = "sha256-FGEYfl6BSSK9RbGEIoynv1tzkFFn0kafxr5Jux/moP0=";
      };
    });

    agda = prev.agda.withPackages (p: [
      p.standard-library
    ]);

    sway-unwrapped = prev.sway-unwrapped.overrideAttrs (o: {
      patches = (o.patches or []) ++ [
        (prev.fetchpatch {
          name = "sway-swipe-gestures.patch";
          url = "https://patch-diff.githubusercontent.com/raw/swaywm/sway/pull/4952.patch";
          sha256 = "sha256-g/0RNqtwM9dQVDIHHpnS7QeVDi/weYnOe9Rq0giIhmw=";
        })
      ];
    });
  };
in
hole // { inherit hole; }
