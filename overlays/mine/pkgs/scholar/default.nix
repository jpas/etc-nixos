{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "scholar-${version}";
  version = "2020-01-07";

  src = fetchFromGitHub {
    owner = "cgxeiji";
    repo = "scholar";
    rev = "f9c48c0855173009c418766c7fd7c16c051021de";
    sha256 = "17lf5nyyjpq4pjcil1z378z1bkij14xym2n7rbsd7bm8clsf4vh0";
  };

  patches = [
    ./0001-add-go-modules-support.patch
  ];

  vendorSha256 = "0gvi79pmiy4rnqa1a9xwl3qz7al57808bzaxv47isfw6fs4cbc2r";

  meta = {
    description = "Reference Manager in Go";
    homepage = "https://github.com/cgxeiji/scholar";
    license = lib.licenses.mit;
  };
}
