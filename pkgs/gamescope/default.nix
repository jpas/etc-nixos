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
}:

stdenv.mkDerivation rec {
  pname = "gamescope";
  version = "unstable-2021-05-01";

  src = fetchFromGitHub {
    owner = "Plagman";
    repo = "gamescope";
    rev = "496b5f58d2882690c0cc415b242c133ea91a8b9c";
    hash = "sha256-D2Amibvhm7p9ZRC87bH2X9JKAf13ozWZPxO/JUvxbaw=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols ];

  buildInputs = [
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
    libliftoff
    libudev
    libxkbcommon
    mesa
    pixman
    vulkan-loader
    wayland
    wlroots
    xlibsWrapper
    xwayland
  ];

  meta = with lib; {
    description = "A micro-compositor";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jpas ];
  };
}
