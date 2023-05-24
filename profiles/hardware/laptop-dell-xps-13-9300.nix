{ lib, config, pkgs, ... }:

with lib;

let
  # the default priorities put the speakers above headphones
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
  imports = [
    ./gpu-intel.nix
    ./sound.nix
    ./thunderbolt.nix
  ];

  # Disables i2c_hid because it makes tons of IRQ/s when touchpad is used,
  # draining battery and wasting cycles as it is unused.
  boot.blacklistedKernelModules = [ "i2c_hid" ];

  # Enable fan sensors via smm
  boot.kernelModules = [ "dell_smm_hwmon" ];
  boot.extraModprobeConfig = ''
    options dell-smm-hwmon ignore_dmi=1
  '';

  # Needed for wifi and bluetooth to work
  hardware.enableRedistributableFirmware = mkDefault true;

  services.fwupd.enable = mkDefault true;

  services.pipewire = {
    # TODO: port this to wireplumber
    # media-session.config = {
    #   v4l2-monitor.rules = [
    #     {
    #       matches = [
    #         { "node.name" = "~v4l2_input.*"; }
    #         { "node.name" = "~v4l2_output.*"; }
    #       ];
    #       actions.update-props = {
    #         "node.pause-on-idle" = false;
    #       };
    #     }
    #     {
    #       matches = [
    #         { "node.name" = "v4l2_input.pci-0000_00_14.0-usb-0_9_1.0"; }
    #       ];
    #       actions.update-props = {
    #         "node.description" = "Integrated Webcam";
    #       };
    #     }
    #     {
    #       matches = [
    #         { "node.name" = "v4l2_input.pci-0000_00_14.0-usb-0_9_1.2"; }
    #       ];
    #       actions.update-props = {
    #         "node.description" = "Integrated Webcam - IR";
    #       };
    #     }
    #   ];
    # };
  };

  environment.systemPackages = [
    pkgs.libsmbios # For interacting with Dell BIOS/UEFI
  ];

  systemd.services = {
    dell-thermal-mode = {
      wantedBy = [ "multi-user.target" "post-resume.target" ];
      after = [ "post-resume.target" ];

      serviceConfig = {
        Type = "oneshot";
        Restart = "no";
        ExecStart = "${pkgs.libsmbios}/bin/smbios-thermal-ctl --set-thermal-mode=quiet";
      };
    };
  };

  systemd.user.services = {
    pipewire-media-session.environment = {
      ACP_PATHS_DIR = "${acp-paths}";
    };

    wireplumber.environment = {
      ACP_PATHS_DIR = "${acp-paths}";
    };
  };
}
