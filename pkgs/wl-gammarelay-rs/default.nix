{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-gammarelay-rs";
  version = "0.3.0";

  src = fetchFromGitHub {
    name = pname;
    owner = "MaxVerevkin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XiE1ZHBeepNPorp1iPFBN7xmq0heFgIpONMVMTAimR8=";
  };

  cargoSha256 = "sha256-+VpXOCwmVoPvQbbyy5LX5CvDischNIrjnsoZCVgg08s=";

  meta = with lib; { };
}
