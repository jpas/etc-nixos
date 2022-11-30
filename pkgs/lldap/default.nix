{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
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
    sha256 = "sha256-J1RFhve4j1IfZ0cEPBpD/rCw9jLNiS7nsvvOzi2ZQLg=";
  };

  cargoPatches = [ ./0000-update-cargo-lock.patch ];

  cargoSha256 = "sha256-aJ0mORk0bchyqHp0ma0kEXPs4jR1WXDjsV6RReKHUzo=";

  nativeBuildInputs = [ pkg-config which wasm-pack nodePackages.rollup ];
  buildInputs = [ openssl ];

  postBuild = ''
    ./app/build.sh
  '';

  meta = with lib; { };
}
