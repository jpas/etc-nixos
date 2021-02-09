{ pkgs, nixosConfig, ... }:
let
  hasGUI = nixosConfig.services.xserver.enable;
in rec {
  imports = [
    ./nvim.nix
  ];

  home.packages = with pkgs; let
    hunspell = hunspellWithDicts (with pkgs.hunspellDicts; [ en_CA-large ]);
  in [
    _1password
    chezmoi
    coreutils
    duf
    file
    glances
    gnumake
    hunspell
    modd
    nixfmt
    p7zip
    pandoc
    python39
    ripgrep
    rmapi
    scholar
    tectonic
    tmux
  ] ++ (if hasGUI
  then [
    sage
    discord
    signal-desktop
    spotify
    desmume
    #zoom-us
  ]
  else []);

  #programs.bash.enable = false;

  programs.git = {
    userName = "Jarrod Pas";
    userEmail = "jarrod@jarrodpas.com";
  };

  programs.ssh.enable = false;
  programs.texlive.enable = false;

  dconf.settings = { };

  systemd.user.mounts = {
    home-jpas-archive-kado = {
      Unit = {
        Description = "Mount archive from kado";
        After = [ "basic.target" ];
        Requires = [ "basic.target" ];
      };

      Install = {
        WantedBy = [ "basic.target" ];
      };

      Mount = {
        What = "jpas@kado.jpas.xyz:/data/jpas/archive";
        Where = "/home/jpas/archive/kado";
        Type = "fuse.sshfs";
        Options = builtins.concatStringsSep "," [
          "IdentityFile=/home/jpas/.ssh/id_ed25519"
          "x-systemd.automount"
          "reconnect"
        ];
      };
    };
  };
}
