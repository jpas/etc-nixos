{ lib
, buildPythonPackage
, fetchFromGitHub
, mupdf
, poetry
, pymupdf
, libjpeg
, shapely
, fetchPypi
, freetype
}:

let
  pymupdf_ = pymupdf.overrideAttrs (o: rec {
    name = "${o.pname}-${version}";
    version = "1.18.12";
    buildInputs = o.buildInputs ++ [ freetype libjpeg ];
    src = fetchPypi {
      pname = "PyMuPDF";
      inherit version;
      hash = "sha256-2vSOejSuJfBQdojDUEMeWdQgcyY0fL/MdnlgwwOVVfs=";
    };

    patches = [
      ./0000-pymupdf-fix-library-linking.patch
    ];
  });
in
buildPythonPackage rec {
  pname = "remarks";
  version = "2021-03-12";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lucasrla";
    repo = pname;
    rev = "46fc39bbbe6d1f5a48e4c9aa265861c367077bc6";
    hash = "sha256-XRnt7XYOvE7OpdHex0nGJzTLsBaUiX8GAx51495dWNE=";
  };

  patches = [
    ./0000-rollback-pymupdf-version.patch
    ./0001-add-executable.patch
  ];

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [ pymupdf_ shapely ];
}
