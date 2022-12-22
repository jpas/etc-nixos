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

  srcs = [
    (fetchFromGitHub {
      name = pname;
      owner = "nitnelave";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-J1RFhve4j1IfZ0cEPBpD/rCw9jLNiS7nsvvOzi2ZQLg=";
    })
    (fetchTarball {
      name = "${pname}-app";
      url = "https://github.com/nitnelave/lldap/releases/download/v${version}/lldap-x86_64-v${version}.tar.gz";
      sha256 = "1cczmr7pjldhchlkmbkzggr28calakqv8rmsqj7ipv1m1hp7mbig";
    })
  ];

  sourceRoot = pname;

  cargoPatches = [ ./0000-update-cargo-lock.patch ];

  cargoSha256 = "sha256-pO0kEVzgfOGn4PBzTrUyVfcelS+W6RfkYURTUXpms2k=";

  nativeBuildInputs = [ pkg-config which wasm-pack nodePackages.rollup ];
  buildInputs = [ openssl ];

  postBuild = ''
    mkdir -p $out/app
    cp ../${pname}-app/release/x86_64/index.html $out/app
    cp ../${pname}-app/release/x86_64/main.js $out/app
    cp -r ../${pname}-app/release/x86_64/pkg $out/app
  '';

  meta = with lib; {
    platforms = platforms.linux;
  };
}
