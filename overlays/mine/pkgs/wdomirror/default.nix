{ lib, stdenv, ninja, meson, fetchFromGitHub, wayland, wayland-protocols
, pkg-config, ... }:

stdenv.mkDerivation {
  pname = "wdomirror";
  version = "2021-01-08";

  src = fetchFromGitHub {
    owner = "progandy";
    repo = "wdomirror";
    rev = "e4a4934e6f739909fbf346cbc001c72690b5c906";
    sha256 = "1fz0sajhdjqas3l6mpik8w1k15wbv65hgh9r9vdgfqvw5l6cx7jv";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland wayland-protocols ];

  buildInput = [ ];

  installPhase = ''
    install -m755 -D wdomirror $out/bin/wdomirror
  '';
}
