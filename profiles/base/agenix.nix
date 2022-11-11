{ lib, flakes, ... }:
{
  imports = [ flakes.agenix.nixosModules.age ];
}
