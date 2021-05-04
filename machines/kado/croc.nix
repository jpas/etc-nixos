{ ... }:
{
  services.croc = {
    enable = true;
    ports = [ 39645 39646 39647 39648 39649 39650 ];
    openFirewall = true;
  };
}
