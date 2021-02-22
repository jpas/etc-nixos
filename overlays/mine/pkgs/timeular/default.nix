{ lib, fetchurl, appimageTools }:

let
  pname = "timeular";
  version = "2020-10-19";
  name = "${pname}-${version}";

in appimageTools.wrapType2 {
  inherit name;

  src = fetchurl {
    name = "${pname}-${version}.AppImage";
    url =
      "https://s3.amazonaws.com/timeular-desktop-packages/linux/production/Timeular.AppImage";
    sha256 = "1s5jjdl1nzq9yd582lqs904yl10mp0s25897zmifmcbw1vz38bar";
  };

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
  '';

  extraPkgs = pkgs: with pkgs; [ libsecret ];
}
