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
  #timeular = callPackage ./pkgs/timeular { };
  #noisetorch = callPackage ./pkgs/noisetorch { };
  librnnoise-ladspa = callPackage ./pkgs/librnnoise-ladspa { };

  gnomeExtensions = super.gnomeExtensions // {
    pop-shell = callPackage ./pkgs/pop-shell { };
  };

  intel-undervolt = callPackage ./pkgs/intel-undervolt { };

  #spotify = super.spotify-unwrapped.override {
  #  libpulseaudio = self.pipewire.pulse;
  #};

  #discord = super.discord.override {
  #  libpulseaudio = self.pipewire.pulse;
  #};

  #steam = super.steam.overrideAttrs (old: {
  #  steam-runtime-wrapped = old.steam-runtime-wrapped.override {
  #    libpulseaudio = self.pipewire.pulse;
  #  };
  #});

  ddccontrol-db = super.ddccontrol-db.overrideAttrs (old: rec {
    version = "20201221";
    name = "ddccontrol-db-${version}";

    src = super.fetchFromGitHub {
      owner = "ddccontrol";
      repo = "ddccontrol-db";
      rev = version;
      sha256 = "1sryyjjad835mwc7a2avbij6myln8b824kjdr78gc9hh3p16929b";
    };
  });
}
