{ lib
, fetchFromGitHub
, rustPlatform
, pam
}:

rustPlatform.buildRustPackage rec {
  pname = "lemurs";
  version = "0.3.0";

  src = fetchFromGitHub {
    name = pname;
    owner = "coastalwhite";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FPozxhpwzrl32GBL8b69fdAIuoRZ7e0nyCm83hdgcrM=";
  };

  cargoSha256 = "sha256-tkD/6CeEFNfIuBIRIRQRKOpla8Me9OFUZ4WKyBRRGaU=";

  buildInputs = [ pam ];

  postBuild = ''
    install -t $out/etc -Dm644 extra/config.toml
  '';

  meta = with lib; {
    platforms = platforms.linux;
  };
}
