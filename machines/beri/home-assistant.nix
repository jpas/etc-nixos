{
  networking.firewall.allowedTCPPorts = [ 8123 ];
  virtualisation.oci-containers.containers = {
    home-assistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      pull = "always";
      privileged = true;
      extraOptions = [ "--network=host" ];
      volumes = [
        "/var/lib/home-assistant:/config"
        "/etc/localtime:/etc/localtime:ro"
        "/run/dbus:/run/dbus:ro"
      ];
    };
  };
}
