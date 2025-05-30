{ lib
, replaceVarsWith
, bash
, systemd
}:

replaceVarsWith {
  src = ./gammactl;

  replacements =  {
    inherit bash systemd;
  };

  name = "gammactl";
  dir = "bin";
  isExecutable = true;

  meta = with lib; {
    mainProgram = "gammactl";
    platforms = platforms.linux;
  };
}
