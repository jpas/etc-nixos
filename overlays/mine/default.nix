self: super:
let
  callPackage = super.lib.callPackageWith super;
in rec {
  #wireshark = super.wireshark.override {
  #  libpcap = super.libpcap.overrideAttrs (old: {
  #    nativeBuildInputs = old.nativeBuildInputs
  #      ++ [ super.bluez.dev super.pkgconfig ];
  #  });
  #};

  fancon = callPackage ./pkgs/fancon { };
  scholar = callPackage ./pkgs/scholar { };
  srvfb = callPackage ./pkgs/srvfb { };
  librnnoise-ladspa = callPackage ./pkgs/librnnoise-ladspa { };
}
