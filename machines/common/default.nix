{ lib, meta, config, ... }:

with lib;

let
  hasPublicKeys = hasAttrByPath [ "ssh" "publicKeys" ];
  hasNet = hasAttr "net";

  machines = flip filterAttrs meta.machines
    (_: m: (hasNet m) && (hasPublicKeys m));

  hostsFor = flip mapAttrs machines
    (name: machine: [ name ] ++ (pipe machine.net [
      attrNames
      (map (net: forEach meta.net.${net}.domains (d: "${name}.${d}")))
      concatLists
    ]));

in
{
  imports = [ ./aleph.nix ];

  programs.ssh.knownHosts = flip concatMapAttrs machines
    (name: machine: pipe machine.ssh.publicKeys [
      (imap0 (i: publicKey: {
        name = "${name}/${toString i}";
        value = {
          extraHostNames = hostsFor.${name};
          inherit publicKey;
        };
      }))
      listToAttrs
    ]);
}
