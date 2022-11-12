{ lib, config, pkgs, ... }:

with lib;

{
  imports = [
    ./intel-cpu.nix
    ./intel-gpu.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "rtsx_pci_sdmmc" ];

  # Disables i2c_hid because it makes tons of IRQ/s when touchpad is used,
  # draining battery and wasting cycles as it is unused.
  boot.blacklistedKernelModules = [ "i2c_hid" ];

  # Enable fan sensors via smm
  boot.kernelModules = [ "dell_smm_hwmon" ];
  boot.extraModprobeConfig = ''
    options dell-smm-hwmon ignore_dmi=1
  '';

  powerManagement.cpuFreqGovernor = "powersave";

  # Needed for wifi and bluetooth to work
  hardware.enableRedistributableFirmware = mkDefault true;

  hardware.video.hidpi.enable = mkDefault true;

  services.fwupd.enable = mkDefault true;

  services.hardware.bolt.enable = mkDefault true;

  services.pipewire = {
    media-session.config = {
      v4l2-monitor.rules = [
        {
          matches = [
            {
              "node.name" = "~v4l2_input.*";
            }
            {
              "node.name" = "~v4l2_output.*";
            }
          ];
          actions.update-props = {
            "node.pause-on-idle" = false;
          };
        }
        {
          matches = [
            {
              "node.name" = "v4l2_input.pci-0000_00_14.0-usb-0_9_1.0";
            }
          ];
          actions.update-props = {
            "node.description" = "Integrated Webcam";
          };
        }
        {
          matches = [
            {
              "node.name" = "v4l2_input.pci-0000_00_14.0-usb-0_9_1.2";
            }
          ];
          actions.update-props = {
            "node.description" = "Integrated Webcam - IR";
          };
        }
      ];
    };
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

  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
  };
}
