{ lib
, config
, pkgs
, ...
}:

with lib;

let
  multiPkgs = pkgs: attrValues {
    inherit (pkgs)
      libva
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
      ;
  };
in
{
  hardware.opengl = {
    extraPackages = (multiPkgs pkgs) ++ (attrValues {
      inherit (pkgs)
        intel-compute-runtime
        intel-media-driver
        ;
    });
    extraPackages32 = multiPkgs pkgs.pkgsi686Linux;
    driSupport32Bit = mkDefault config.hardware.opengl.driSupport;
  };

  services.xserver = {
    # Use modesetting since intel is outdated and not recommended.
    # See: https://nixos.org/manual/nixos/stable/index.html#sec-x11--graphics-cards-intel
    videoDrivers = mkDefault [ "modesetting" ];

    # The modesetting driver supports "Glamor" which accelerates 2D graphics
    # using OpenGL.
    useGlamor = mkDefault true;
  };
}
