{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, boost
, p7zip
, bzip2
, cmake
, git
, mariadb-connector-c
, readline
}:

stdenv.mkDerivation {
  pname = "trinity";
  version = "2021-07-25-git-3.3.5";

  outputs = [ "out" "sql" ];

  full-world = fetchzip {
    url = "https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.21061/TDB_full_world_335.21061_2021_06_15.7z";
    hash = "sha256-l3jHPQanqa52mNcx142jl+3zRczYzW/kcuFupGWTV/w=";
    postFetch = ''
      ${p7zip}/bin/7z x $downloadedFile
      mkdir  $out
      mv *.sql $out/
    '';
  };

  src = fetchFromGitHub {
    owner = "TrinityCore";
    repo = "TrinityCore";
    rev = "84c8d21ad38ade64444e2394f090b49d2ffb5c51";
    hash = "sha256-9P84xQ4JtDodmNuLceUMt/eSrz4ZP/zDh1kQO1KCdbA=";
  };

  cmakeFlags = [
    "-DCOPY_CONF=0"
    "-DCONF_DIR=/etc/trinity"
    "-DMYSQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mariadb"
  ];

  postInstall = ''
    mkdir -p $sql
    cp -vrt $sql/ ../sql
  '';

  nativeBuildInputs = [ cmake git ];
  buildInputs = [ bzip2 readline boost mariadb-connector-c.dev ];
}
