{ ...
}:
{
  services.pipewire = {
    enable = true;
    # XXX: waiting for unstable to catch up for
    # https://github.com/NixOS/nixpkgs/pull/93725
    pulse.enable = true;
    alsa.enable = true;
  };

  hardware.pulseaudio.enable = false;
}
