final: prev:
let
  inherit (prev) lib callPackage;

  hole = rec {
    lib = prev.lib.extend (import ../lib);

    makeOzoneWrapper = { bin, target, ... }:
      final.writeShellScriptBin bin ''
        declare -a args
        if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
          args+=(--enable-features=UseOzonePlatform --ozone-platform=wayland)
        fi
        exec "${target}" "''${args[@]}" "$@"
      '';

    pipewire = prev.pipewire.overrideAttrs (o: {
      patches = (o.patches or []) ++ [
        ./pipewire-fix-port-priority.patch
      ];
    });
    swaynagmode = callPackage ./swaynagmode { };
    ftpserver = callPackage ./ftpserver { };
    gamescope = callPackage ./gamescope {
      inherit libliftoff;
      meson = meson_0_59_1;
    };
    libliftoff = callPackage ./libliftoff { };
    oauth2ms = callPackage ./oauth2ms { };
    oauth2token = callPackage ./oauth2token { };
    trinity = callPackage ./trinity { stdenv = final.clang11Stdenv; };
    xplr = callPackage ./xplr { };

    steam = prev.steam.override {
      extraPkgs = pkgs: [ pkgs.libunwind ];
    };

    signal-desktop = makeOzoneWrapper {
      bin = "signal";
      target = "${prev.signal-desktop}/bin/signal-desktop";
    };

    discord = makeOzoneWrapper {
      bin = "discord";
      target = "${prev.discord}/bin/Discord";
    };

    #kanshi = prev.kanshi.overrideAttrs (_: {
    #  version = "2021-02-02-unstable";
    #  src = final.fetchFromGitHub {
    #    owner = "emersion";
    #    repo = "kanshi";
    #    rev = "dabd7a29174a74b3f21a2b4cc3d9dc63221761bb";
    #    hash = "sha256-FGEYfl6BSSK9RbGEIoynv1tzkFFn0kafxr5Jux/moP0=";
    #  };
    #});

    agda = prev.agda.withPackages (p: [
      p.standard-library
    ]);

    #sway-unwrapped = prev.sway-unwrapped.overrideAttrs (o: {
    #  patches = (o.patches or []) ++ [
    #    (prev.fetchpatch {
    #      name = "sway-swipe-gestures.patch";
    #      url = "https://patch-diff.githubusercontent.com/raw/swaywm/sway/pull/4952.patch";
    #      sha256 = "sha256-g/0RNqtwM9dQVDIHHpnS7QeVDi/weYnOe9Rq0giIhmw=";
    #    })
    #  ];
    #});

    meson_0_59_1 = prev.meson.overrideAttrs (old: rec {
      pname = "meson";
      version = "0.59.1";
      name = "${pname}-${version}";
      src = prev.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-21hqRRZQ1Gu+EJhKh7edm83ByuvzjY4Yn4hI+NUCNW0=";
      };
      patches =
        (lib.flip lib.filter old.patches
          (patch: ! lib.hasSuffix "gir-fallback-path.patch" patch)
        ) ++ [
          (prev.fetchpatch {
            name = "git-fallback-path.patch";
            url = "https://raw.githubusercontent.com/NixOS/nixpkgs/3c9014a761ba5a8af56e04035cb1a20c706d814a/pkgs/development/tools/build-managers/meson/gir-fallback-path.patch";
            sha256 = "sha256-QfkS6pAmF+D51qgIyOTMvGvlAtn4S4dIe+h3GG1GHkA=";
          })
        ];
    });

    wine64Wayland = prev.wine64.overrideAttrs (old: rec {
      pname = "wine64";
      version = "6.21+wayland";
      name = "${pname}-${version}";
      src = final.fetchFromGitLab {
        domain = "gitlab.collabora.com";
        owner = "alf";
        repo = "wine";
        rev = "f4824e92776dcb7efa217c5845460bc82184274a";
        sha256 = "sha256-jJisQ3EuaZhqtgEINvqVhSLgBwFCxahjRC4N4xwFN/0=";
      };
      buildInputs = old.buildInputs ++ [
        final.wayland
        final.egl-wayland
        final.libxkbcommon
        final.libGL
      ];
      patches = [ ];
      configureFlags = old.configureFlags ++ [ "--with-x=no" "--with-wayland" ];
    });
  };
in
hole // { inherit hole; }
