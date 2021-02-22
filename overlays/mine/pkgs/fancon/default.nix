{ stdenv, lib, fetchFromGitHub, cmake, lm_sensors, boost, protobuf, grpc, which
, clang }:

stdenv.mkDerivation rec {
  name = "fancon-${version}";
  version = "v0.23.3";

  src = fetchFromGitHub {
    owner = "hbriese";
    repo = "fancon";
    rev = "${version}";
    sha256 = "1sy6xdwmnxpr79brz4d5n2hv0cbgv9cyiv8fqmrgv9p47iiqyl7c";
  };

  nativeBuildInputs = [ which cmake ];
  buildInputs = [ clang boost lm_sensors protobuf grpc ];

  cmakeFlags = [ "-DNVIDIA_SUPPORT=OFF" ];

  meta = {
    description = "A fan control daemon";
    homepage = "https://github.com/hbriese/fancon";
    license = lib.licenses.asl20;
  };
}
