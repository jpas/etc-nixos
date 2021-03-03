{ lib
, ...
}:

with lib;

{
  services.throttled = {
    enable = mkDefault true;

    # *** WARNING *** these were tweaked specifically for my machine, using
    # them on your own machine may result in instability
    extraConfig = generators.toINI { } {
      GENERAL = { Enabled = true; };

      AC = {
        Update_Rate_s = 5;
        PL1_Tdp_W = 25;
        PL2_Tdp_W = 32;
        Trip_Temp_C = 94;
        cTDP = 2;
      };

      BATTERY = {
        Update_Rate_s = 30;
        PL1_Tdp_W = 15;
        PL2_Tdp_W = 18;
      };

      UNDERVOLT = rec {
        CORE = -69;
        CACHE = CORE;
        GPU = 0;
        UNCORE = 0;
        ANALOGIO = 0;
      };
    };
  };
}
