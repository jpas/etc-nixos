{ ... }:

let

  disable = o: o // { status = "disable"; };

  laptop = {
    criteria = "Sharp Corporation 0x14CC 0x00000000";
    scale = 2.0;
    status = "enable";
  };

  monitor = {
    criteria = "Dell Inc. DELL U2720Q 86CZZ13";
    scale = 1.0;
    status = "enable";
  };

  tv = {
    criteria = "Goldstar Company Ltd LG TV 0x00000000";
    scale = 1.0;
    status = "enable";
  };

in {
  home-manager.imports = [
    ({ ... }: {
      services.kanshi.profiles = {
        nomad = { outputs = [ laptop ]; };
        docked = { outputs = [ (disable laptop) monitor ]; };
        docked-plus-tv = { outputs = [ (disable laptop) monitor tv ]; };
      };
    })
  ];
}
