{ lib, rustPlatform, fetchFromGitHub, cmake, pkg-config, pango }:

rustPlatform.buildRustPackage rec {
  pname = "yofi";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "l4l";
    repo = pname;
    rev = version;
    sha256 = "03dl5149nn9yhmgs0bn5na74vjkyd9cyziradhjg5p8rplyp0ghf";
  };

  cargoSha256 = "01i9xqcvz4529x3mfl39n3h1xydwa2d93nj7hcag7py6zsqzvn6z";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ pango ]; # not actually the thing we need?

  meta = with lib; {
    description = "A minimalistic menu for wayland";
    inherit (src) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ jpas ];
    broken = true;
  };
}
