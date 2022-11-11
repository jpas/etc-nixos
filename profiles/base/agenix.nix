{ lib, flakes, ... }:
lib.mkIf (flakes ? agenix) {
  imports = [ flakes.agenix.nixosModules.age ];
}
