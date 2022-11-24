{
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /srv/exports        10.39.1.254(insecure,rw,async,no_subtree_check,crossmnt,fsid=root)
    /srv/exports/aleph  10.39.1.254(insecure,rw,async,no_subtree_check)
  '';

  fileSystems."/srv/exports/aleph" = {
    device = "/aleph";
    options = [ "bind" ];
  };
}
