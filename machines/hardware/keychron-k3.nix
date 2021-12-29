{ ... }:
{
  # keychron k3 advertises itself as an apple keyboard with F1-F12 requiring
  # fn to be pressed.
  # echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=0
  '';
}
