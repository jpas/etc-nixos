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
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "libliftoff";
    rev = "v${version}";
    hash = lib.fakeSha256;
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ libdrm ];

  meta = with lib; {
    description = " Lightweight KMS plane library";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jpas ];
  };
}
