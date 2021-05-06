{
  programs.oauth2ms = {
    enable = true;
    settings = {
      tenant_id = "common";
      client_id = "08162f7c-0fd2-4200-a84a-f25a4db0b584";
      client_secret = "TxRBilcHdC6WGBee]fs?QR:SJ8nI[g82";
      redirect_host = "localhost";
      redirect_path = "/";
      redirect_port = "51268";
      scopes = [
        "https://outlook.office.com/IMAP.AccessAsUser.All"
        "https://outlook.office.com/SMTP.Send"
      ];
    };
  };
}
