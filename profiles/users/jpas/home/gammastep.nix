{ config, ... }: {
  services.gammastep = {
    latitude = config.hole.location.latitude;
    longitude = config.hole.location.longitude;
    temperature = {
      day = 3600;
      night = 2700;
    };
  };
}
