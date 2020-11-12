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
  timeular = callPackage ./pkgs/timeular { };
  #noisetorch = callPackage ./pkgs/noisetorch { };
  librnnoise-ladspa = callPackage ./pkgs/librnnoise-ladspa { };

  gnomeExtensions = super.gnomeExtensions // {
    pop-shell = callPackage ./pkgs/pop-shell { };
  };

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
}
