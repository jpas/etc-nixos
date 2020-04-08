{ ... }: {
  imports = [
    # Include custom generic configurations.
    ../common.nix
    ../role/desktop.nix
    ../user/jpas.nix
    ../user/kbell.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "shiro"; # Define your hostname.
  networking.domain = "jpas.xyz";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.interfaces.eno1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}

