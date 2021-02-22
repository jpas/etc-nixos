{ pkgs, ... }: {
  services.factorio = {
    enable = true;
    openFirewall = true;
  };
}
