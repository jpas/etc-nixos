{ stdenv, cmake, fetchFromGitHub, lib, ... }:

stdenv.mkDerivation rec {
  pname = "librnnnoise-ladspa";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "werman";
    repo = "noise-suppression-for-voice";
    rev = "v${version}";
    sha256 = "18bq5b50xw3d4r1ildinafpg3isb9y216430h4mm9wr3ir7h76a7";
  };

  buildInputs = [ cmake ];
}
