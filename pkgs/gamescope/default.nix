{ lib
, stdenv
, fetchFromGitHub

, meson
, ninja
, pkg-config
, wayland-protocols

, SDL2
, glslang
, pipewire
, stb
, vulkan-loader
, wlroots
, xorg
, libseat
}:

stdenv.mkDerivation rec {
  pname = "gamescope";
  version = "3.11.48.1";

  src = fetchFromGitHub {
    owner = "Plagman";
    repo = "gamescope";
    rev = version;
    sha256 = "sha256-QRPMAVExk7f3pgI9PGjK+o/BQzyqNtjBKiZ794Oqg08=";
    fetchSubmodules = true;
  };

  patches = [
    ./0000-disable-meta-key-forwarding.patch
    #./0001-implement-extra-mouse-buttons.patch
    #./0002-show-cursor-on-focus-lost.patch
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-protocols
  ];

  preConfigure = ''
    mkdir -p subprojects/stb
    ln -s ${stb}/include/stb/stb_image.h subprojects/stb
    ln -s ${stb}/include/stb/stb_image_write.h subprojects/stb
    ln -s ../packagefiles/stb/meson.build subprojects/stb
  '';

  buildInputs = [
    xorg.libXcomposite
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXres
    xorg.libXtst
    glslang
    pipewire
    SDL2
    vulkan-loader
  ] ++ wlroots.buildInputs;

  meta = with lib; {
    description = "A micro-compositor";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jpas ];
  };
}
