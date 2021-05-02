{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libdrm
}:

stdenv.mkDerivation rec {
  pname = "libliftoff";
  version = "unstable-2021-03-31";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "libliftoff";
    rev = "b08bbaa5e6331ed273c4bbd867143bf776c18207";
    hash = "sha256-tw82AK+LC/+akDpGIJ2Do1e1cALeik2oFnHgsWN7laI=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ libdrm ];
}
