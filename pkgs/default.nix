final: prev:
let
  inherit (prev) lib callPackage;

  updateDerivation = der: f: der.overrideAttrs (old:
    let new = f old; in
    assert lib.versionOlder old.version new.version;
    new // {
      name = "${old.pname}-${new.version}";
    });

  makeOzoneWrapper = { bin, target, ... }:
    final.writeShellScriptBin bin ''
      declare -a args
      if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        args+=(--enable-features=UseOzonePlatform --ozone-platform=wayland)
      fi
      exec "${target}" "''${args[@]}" "$@"
    '';

  hole = rec {

    #swaynagmode = callPackage ./swaynagmode { };
    ftpserver = callPackage ./ftpserver { };
    #gamescope = callPackage ./gamescope { };
    #libliftoff = callPackage ./libliftoff { };
    #oauth2ms = callPackage ./oauth2ms { };
    #oauth2token = callPackage ./oauth2token { };
    #proton-ge = callPackage ./proton-ge { };
    #trinity = callPackage ./trinity { stdenv = final.clang11Stdenv; };
    #xplr = callPackage ./xplr { };

    #steam = prev.steam.override {
    #  extraPkgs = pkgs: [ pkgs.libunwind ];
    #};

    #kanshi = prev.kanshi.overrideAttrs (_: {
    #  version = "2021-02-02-unstable";
    #  src = final.fetchFromGitHub {
    #    owner = "emersion";
    #    repo = "kanshi";
    #    rev = "dabd7a29174a74b3f21a2b4cc3d9dc63221761bb";
    #    hash = "sha256-FGEYfl6BSSK9RbGEIoynv1tzkFFn0kafxr5Jux/moP0=";
    #  };
    #});

    #agda = prev.agda.withPackages (p: [
    #  p.standard-library
    #]);

    #sway-unwrapped = prev.sway-unwrapped.overrideAttrs (o: {
    #  patches = (o.patches or []) ++ [
    #    (prev.fetchpatch {
    #      name = "sway-swipe-gestures.patch";
    #      url = "https://patch-diff.githubusercontent.com/raw/swaywm/sway/pull/4952.patch";
    #      sha256 = "sha256-g/0RNqtwM9dQVDIHHpnS7QeVDi/weYnOe9Rq0giIhmw=";
    #    })
    #  ];
    #});

    #wine64Wayland = prev.wine64.overrideAttrs (old: rec {
    #  name = "wine64+wayland-${version}";
    #  version = "6.21";
    #  src = final.fetchFromGitLab {
    #    domain = "gitlab.collabora.com";
    #    owner = "alf";
    #    repo = "wine";
    #    rev = "f4824e92776dcb7efa217c5845460bc82184274a";
    #    sha256 = "sha256-jJisQ3EuaZhqtgEINvqVhSLgBwFCxahjRC4N4xwFN/0=";
    #  };
    #  buildInputs = old.buildInputs ++ [
    #    final.wayland
    #    final.egl-wayland
    #    final.libxkbcommon
    #    final.libGL
    #  ];
    #  patches = [ ];
    #  configureFlags = old.configureFlags ++ [ "--with-x=no" "--with-wayland" ];
    #});
  };
in
hole // { inherit hole; }
