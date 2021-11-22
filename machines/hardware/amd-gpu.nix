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
      vaapiVdpau
      ;
  };
in
{
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl = {
    extraPackages = (multiPkgs pkgs) ++ (attrValues {
      inherit (pkgs)
        rocm-opencl-icd
        ;
    });
    extraPackages32 = multiPkgs pkgs.pkgsi686Linux;
    driSupport32Bit = mkDefault config.hardware.opengl.driSupport;
  };

  services.xserver = {
    # Use modesetting since intel is outdated and not recommended.
    # See: https://nixos.org/manual/nixos/stable/index.html#sec-x11--graphics-cards-intel
    videoDrivers = mkDefault [ "amdgpu" ];

    # The modesetting driver supports "Glamor" which accelerates 2D graphics
    # using OpenGL.
    useGlamor = mkDefault true;
  };
}
