{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "rmapi-hwr-${version}";
  version = "2021-01-07";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = "rmapi-hwr";
    rev = "0cee9ddb885d927e57418fcc34a20abe9377b498";
    sha256 = "0hz0f7n8asc4j4w7cy1754pkkkjjwlzpnpdzjxpi39w260503hmf";
  };

  vendorSha256 = "0g5zw3hrcp28cls8lh9ws7id7kx6wd1v14h3ccpc9kcgggb4qmjg";

  meta = {
    description = "Handwriting recognition for reMarkable";
    #license = lib.licenses.agpl3;
  };
}
