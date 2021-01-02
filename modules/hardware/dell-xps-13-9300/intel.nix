{ config
, lib
, pkgs
, ...
}:

{
  # Use only Intel driver for X11
  services.xserver.videoDrivers = lib.mkDefault [ "intel" ];

  boot.initrd.kernelModules = [ "i915" ];

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver # hardware video acceleration
  ];
}
