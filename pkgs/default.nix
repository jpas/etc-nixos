final: prev:
let
  inherit (prev) lib callPackage;

  updateDerivation = der: f: der.overrideAttrs (old: let new = f old; in
    assert lib.versionOlder old.version new.version;
    new // {
      name = "${old.pname}-${new.version}";
    });

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

    #swaynagmode = callPackage ./swaynagmode { };
    ftpserver = callPackage ./ftpserver { };
    gamescope = callPackage ./gamescope { };
    libliftoff = callPackage ./libliftoff { };
    oauth2ms = callPackage ./oauth2ms { };
    oauth2token = callPackage ./oauth2token { };
    proton-ge = callPackage ./proton-ge { };
    trinity = callPackage ./trinity { stdenv = final.clang11Stdenv; };
    xplr = callPackage ./xplr { };

    steam = prev.steam.override {
      extraPkgs = pkgs: [ pkgs.libunwind ];
    };

    pipewire = updateDerivation prev.pipewire (old: rec {
      version = "0.3.50";

      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "pipewire";
        repo = "pipewire";
        rev = version;
        sha256 = "sha256-OMFtHduvSQNeEzQP+PlwfhWC09Jb8HN4SI42Z9KpZHE=";
      };

      patches = old.patches ++ [
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/pipewire/pipewire/-/commit/d3ea3142e1a4de206e616bc18f63a529e6b4986a.patch";
          sha256 = "sha256-2MTCOwQEA7UAm/eigHDHA+8oFs4JgQfoMHnfzNBjqvI=";
        })
      ];
    });

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

    meson_0_59_1 = updateDerivation prev.meson (old: rec {
      version = "0.59.1";

      src = prev.python3.pkgs.fetchPypi {
        inherit (old) pname;
        inherit version;
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
      name = "wine64+wayland-${version}";
      version = "6.21";
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

    factorio-headless = prev.factorio-headless.overrideAttrs (old: {
      src = prev.fetchurl {
        name = "factorio_headless_x64-1.1.57.tar.xz";
        url = "https://factorio.com/get-download/1.1.57/headless/linux64";
        sha256 = "sha256-tWHdy+T2mj5WURHfFmALB+vUskat7Wmeaeq67+7lxfg=";
      };
    });
  };
in
hole // { inherit hole; }
