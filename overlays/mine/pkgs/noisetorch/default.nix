{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "noisetorch-${version}";
  version = "0.7.2-beta";

  src = fetchFromGitHub {
    owner = "lawl";
    repo = "NoiseTorch";
    rev = "${version}";
    sha256 = "06xlqjma8h7lcnqgc9226blps6m9dp487hk71lslfxj0jkay548k";
  };

  vendorSha256 = null;
}
