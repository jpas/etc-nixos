{ lib
, stdenv
, fetchFromGitHub
, SDL2
, vulkan-loader
, glslang
, libX11
, libXcomposite
, libXdamage
, libXext
, xcbutil
, xcbutilerrors
, xcbutilwm
, libXfixes
, libXi
, libXrender
, libXres
, libXtst
, libXxf86vm
, libcap
, libdrm
, libinput
, libliftoff
, libudev
, libxkbcommon
, pipewire
, mesa
, meson
, ninja
, pixman
, pkg-config
, wayland
, wayland-protocols
, wlroots
, xinput
, xlibsWrapper
, xwayland
, stb
, cmake
, libseat
}:

stdenv.mkDerivation rec {
  pname = "gamescope";
  version = "unstable-2021-09-28";

  src = fetchFromGitHub {
    owner = "Plagman";
    repo = "gamescope";
    rev = "f55106a344617e97399e25962e6277a175f2893b";
    sha256 = "sha256-JE4IYpUOSt0kMq7jQguG+sO6+UefFR+W4u9K84aKBjc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ meson cmake pkg-config wayland-protocols ];

  preConfigure = ''
    mkdir -p subprojects/stb
    ln -s ${stb}/include/stb/stb_image.h subprojects/stb
    ln -s ../packagefiles/stb/meson.build subprojects/stb

    sed -i 's/>=0.58.1/>=0.56.0/' subprojects/wlroots/meson.build
    sed -i 's/global_build_root/build_root/' subprojects/wlroots/meson.build
  '';

  buildInputs = [
    libseat
    pipewire
    SDL2
    glslang
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXi
    libXrender
    libXres
    libXtst
    libXxf86vm
    libcap
    libdrm
    libinput
    libudev
    xcbutilerrors
    xcbutilwm
    libxkbcommon
    mesa
    pixman
    vulkan-loader
    wayland
    xlibsWrapper
    xwayland
  ];

  meta = with lib; {
    description = "A micro-compositor";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jpas ];
  };
}
