{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "oauth2token";
  version = "2020-10-13-git";

  src = fetchFromGitHub {
    owner = "VannTen";
    repo = "oauth2token";
    rev = "c3a3f511366c2fede0f8ce9f149a76ad468a439b";
    hash = lib.fakeHash;
  };

  propagatedBuildInputs = lib.attrValues {
    inherit (python3Packages)
      google-auth-oauthlib
      pyxdg
      ;
  };

  meta = with lib; {
    description = "Simple cli tools to create and use oauth2 tokens";
    homepage = "https://github.com/VannTen/oauth2token";
    license = licenses.gpl30;
    maintainers = with maintainers; [ jpas ];
  };
}
