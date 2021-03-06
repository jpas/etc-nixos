{ lib, stdenv, fetchFromGitHub, pkg-config, ... }:

stdenv.mkDerivation rec {
  pname = "intel-undervolt";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "kitsunyan";
    repo = pname;
    rev = version;
    sha256 = "1fjhjqxhcgzawqmknxhmrkq0b7hjfpw6fcigzyw6vg5yf2lws507";
  };

  nativeBuildInputs = [ pkg-config ];

  configureFlags = [
    "--bindir=${placeholder "out"}/bin"
    "--sysconfdir=/etc"
    "--unitdir=${placeholder "out"}/etc/systemd/system"
    "--enable-systemd"
  ];

  installPhase = ''
    runHook preInstall
    install -D -m755 -t $out/bin intel-undervolt
    install -D -m644 -t $out/lib/systemd/system intel-undervolt.service intel-undervolt-loop.service
    runHook postInstall
  '';

  meta = with lib; {
    description = "Intel CPU undervolting and throttling configuration tool";
    license = licenses.gpl3;
    homepage = "https://github.com/kitsuyan/intel-undervolt";
    platforms = [ "x86_64-linux" ];
  };
}
