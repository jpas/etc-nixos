(import ./user.nix) "jpas" {
  uid = 1000;
  extraGroups = [
    "wheel" # Enable ‘sudo’ for the user.
    "audio"
    "scanner"
    "systemd-journal"
    "networkmanager"
  ];
}
