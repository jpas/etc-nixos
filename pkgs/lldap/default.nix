{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, which
, wasm-pack
, nodePackages
}:

rustPlatform.buildRustPackage rec {
  pname = "lldap";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "nitnelave";
    repo = pname;
    rev = "v${version}";
    sha256 = lib.fakeHash;
  };

  cargoSha256 = lib.fakeHash;

  nativeBuildInputs = [ pkg-config which wasm-pack nodePackages.rollup ];
  buildInputs = [ openssl ];

  postBuild = ''
    ./app/build.sh
  '';

  meta = with lib; { };
};
