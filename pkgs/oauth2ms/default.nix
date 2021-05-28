{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "oauth2ms";
  version = "unstable-2021-02-08";

  src = fetchFromGitHub {
    owner = "harishkrupo";
    repo = pname;
    rev = "37e91bd548060e6f6f2ce65cc98f041e718ce974";
    hash = "sha256-HayqOMI9UTGJkTIBQStuh4DoS8LEtRG7GcTh9nYaCbQ=";
  };

  propagatedBuildInputs = lib.attrValues {
    inherit (python3Packages)
      pyxdg
      msal
      python-gnupg
      ;
  };

  format = "other";

  installPhase = ''
    runHook preInstall
    install -Dm755 ${pname} $out/bin/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "An XOAUTH2 compatible token fetcher for Office365";
    license = licenses.asl20;
    platforms = platforms.any;
    maintainers = with maintainers; [ jpas ];
  };
}
