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
, libliftoff
}:

stdenv.mkDerivation rec {
  pname = "gamescope";
  version = "3.10.3";

  src = fetchFromGitHub {
    owner = "Plagman";
    repo = "gamescope";
    rev = version;
    sha256 = "sha256-Kg+VhAWrQhOiEHqEJVI9M0Ku//wI5IHD+nNnb/DWHas=";
    fetchSubmodules = true;
  };

  patches = [
    ./0000-disable-meta-key-forwarding.patch
    ./0001-implement-extra-mouse-buttons.patch
    ./0002-show-cursor-on-focus-lost.patch
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
