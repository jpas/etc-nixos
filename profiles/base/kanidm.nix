{ lib, ... }:

with lib;

{
  services.kanidm.enableClient = true;

  services.kanidm.clientSettings = {
    uri = "https://idm.pas.sh";
  };
}
