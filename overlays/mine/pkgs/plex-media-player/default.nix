{ super, lib, fetchFromGithub, ... }:

super.plex-media-player.override (rec {
  version = "2.53.0.1063";
  vsnHash = "4c40422c";

  src = fetchFromGithub {
    owner = "plexinc";
    repo = "plex-media-player";
    rev = "v${version}-${vsnHash}";
    sha256 = lib.fakeSha256;
  };
})
