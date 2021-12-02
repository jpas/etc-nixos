{ lib
, config
, pkgs
, ...
}:

with lib;

{
  config = mkIf (config.hole.profiles ? sound) {
    services.pipewire = {
      enable = mkDefault true;

      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;

      # TODO: complain if pipewire and pulseaudio are enabled
      pulse.enable = mkDefault true;
    };

    security.rtkit.enable = mkDefault config.services.pipewire.enable;

    hardware.opengl.extraPackages =
      mkIf config.services.pipewire.enable [ pkgs.pipewire ];

    hardware.opengl.extraPackages32 =
      mkIf config.services.pipewire.enable [ pkgs.pkgsi686Linux.pipewire ];
  };
}
