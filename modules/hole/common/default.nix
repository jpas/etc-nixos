{ lib
, ...
} @ args:

with lib;

let
  nixosHole = (attrByPath [ "nixosConfig" "hole" ] null args);

  mkHoleOption = path: option:
    { ... }: {
      options.hole = setAttrByPath path (mkOption option);

      config = mkIf (nixosHole != null) {
        hole = setAttrByPath path (mkDefault (getAttrFromPath path nixosHole));
      };
    };

  mkProfilesOption = name: default:
    mkHoleOption [ "profiles" name ] {
      type = types.bool;
      inherit default;
    };
in
{
  imports = [
    ./colors.nix

    (mkProfilesOption "graphical" false)
    (mkProfilesOption "minimal" true)

    (mkHoleOption [ "location" "latitude" ] {
      type = types.float;
      default = 52.1;
    })

    (mkHoleOption [ "location" "longitude" ] {
      type = types.float;
      default = -106.4;
    })
  ];
}
