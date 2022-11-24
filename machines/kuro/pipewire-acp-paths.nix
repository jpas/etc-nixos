{ lib, config, pkgs, ... }:

with lib;

let
  acp-paths = pkgs.runCommand "acp-paths" { } ''
    mkdir -p $out
    for f in ${pkgs.pipewire.lib}/share/alsa-card-profile/mixer/paths/*; do
      ln -s $f $out/
    done

    ${concatStringsSep "\n" (mapAttrsToList
      (name: priority: ''
        f=$out/${name}.conf
        cp --remove-destination "$(readlink "$f")" "$f"
        sed -i 's/^priority = [0-9]*/priority = ${toString priority}/' "$f"
      '')
      {
        analog-input-internal-mic = 79;
        analog-input-internal-mic-always = 79;
        analog-output-speaker = 80;
        analog-output-speaker-always = 80;
      }
    )}
  '';
in
{
  systemd.user.services.pipewire-media-session.environment = {
    ACP_PATHS_DIR = "${acp-paths}";
  };

  systemd.user.services.wireplumber.environment = {
    ACP_PATHS_DIR = "${acp-paths}";
  };
}
