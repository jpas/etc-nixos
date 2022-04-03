{
  security.acme.certs."dl.pas.sh" = {
    group = "nginx";
  };

  services.nginx.virtualHosts = {
    "dl.pas.sh" = {
      extraConfig = ''
        autoindex on;
        autoindex_exact_size off;
        root /srv/dl
      '';
    };
  }
}
