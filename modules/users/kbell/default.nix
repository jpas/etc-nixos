(import ../../lib/user.nix) "kbell" {
  uid = 1001;
  extraGroups = [
    "audio"
    "scanner"
    "networkmanager"
  ];
}
