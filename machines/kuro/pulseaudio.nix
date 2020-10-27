{ pkgs
, ...
}:
let
    librnnoise-ladspa = pkgs.librnnoise-ladspa;
    sourceDevice = "alsa_input.pci-0000_00_1f.3.analog-stereo";

    virtualMicrophoneConfig = ''
      load-module module-null-sink sink_name=virtual_microphone.input
      update-sink-proplist virtual_microphone.input device.description="Virtual Microphone"
      update-sink-proplist virtual_microphone.input device.icon_name="audio-input-microphone"

      load-module module-ladspa-sink sink_name=noise_suppressor sink_master=virtual_microphone.input plugin=${librnnoise-ladspa}/lib/ladspa/librnnoise_ladspa.so label=noise_suppressor_stereo control=75
      update-sink-proplist noise_suppressor device.description="Noise Suppressor"
      update-sink-proplist noise_suppressor device.icon_name="audio-card"

      load-module module-remap-source source_name=virtual_microphone.output master=virtual_microphone.input.monitor
      update-source-proplist virtual_microphone.output device.description="Virtual Microphone"
      update-source-proplist virtual_microphone.output device.icon_name="audio-input-microphone"

      load-module module-loopback source=${sourceDevice} sink=noise_suppressor channels=2 latency_msec=10 adjust_time=1 remix=no
      set-default-source virtual_microphone.output
    '';
in {
  environment.systemPackages = [
    librnnoise-ladspa
  ];

  hardware.pulseaudio = {
    extraConfig = ''
    '';

    daemon.config = {
      default-sample-format = "s16le";
      default-sample-rate = "48000";
    };
  };
}
