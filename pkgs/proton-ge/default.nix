{ lib
, fetchurl
, stdenv
, autoPatchelfHook
, gst_all_1
, libva
, pango
, winePackages
, ...
}:

stdenv.mkDerivation rec {
  pname = "proton-ge";
  version = "7.14";

  src = fetchurl {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton7-14/GE-Proton7-14.tar.gz";
    sha256 = "sha256-qEjBJrIFPgSh5Q3FsWw01YQaMWQ49AfhTeRygBf6htk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libva
    pango
  ] ++ gst_all_1.gst-plugins-good.buildInputs
  ++ winePackages.unstable.buildInputs
  ;

  beforePatchPhase = ''
    ls -l
  '';

  patches = [
    ./0000-standalone.patch
  ];

  installPhase = ''
    mkdir -p $out/lib/proton $out/bin
    cp -rv . $out/lib/proton
    ln -sv $out/lib/proton/proton $out/bin/proton
  '';

  meta = {
    architectures = [ "amd64" ];
  };
}

