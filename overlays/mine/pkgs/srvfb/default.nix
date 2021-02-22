{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "srvfb-${version}";
  version = "2020-06-15";

  src = fetchFromGitHub {
    owner = "Merovius";
    repo = "srvfb";
    rev = "aecdce1324f69af003793b09407bd7278bb632e8";
    sha256 = "0jpk422frqmjwj34q69z3yyb4il6q6qfgd9ssz9jpjxgfg3d8nmx";
  };

  patches = [ ./0001-add-go-modules-support.patch ];

  vendorSha256 = "0djjfi3v8nl4q9x0r0p8j7ni3jjvfj29dgglf3vhn27qz4jpc97g";

  meta = {
    description = "Stream a framebuffer device over HTTP";
    homepage = "https://github.com/Merovius/srvfb";
    license = lib.licenses.asl20;
  };
}
