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
    rev = "bc0d0617acdd48e69272771237cad2684c07c901";
    hash = "sha256-6W2Sd1xWnxaP8kNBSEf3T7qwGScAZf38EF1KONrzodc=";
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
