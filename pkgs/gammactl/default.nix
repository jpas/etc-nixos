{ lib
, substituteAll
, systemd
}:

substituteAll {
  name = "gammactl";

  src = ./gammactl;

  dir = "bin";
  isExecutable = true;

  inherit systemd;
}
