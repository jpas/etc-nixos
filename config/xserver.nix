{ pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";

    # Enable touchpad support.
    libinput.enable = true;
  };
}
