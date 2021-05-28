{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  name = "ftpserver-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "fclairamb";
    repo = "ftpserver";
    rev = "v${version}";
    sha256 = "1mx7n8l1jbca4vhs5i1cn64b3qax2na4b4lywf33kzk6w0lmz108";
  };

  vendorSha256 = "08xjakmzzs6ggqj0fv2iygj1rxl0xnjs23j134fis12r3zy9ahcs";

  meta = with lib; {
    description = "Golang based autonomous FTP server";
    homepage = "https://github.com/fclairamb/ftpserver";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
