{
  imports = [
    ../minimal
  ];

  programs.neovim = {
    # TODO gruvbox colors by default
    enable = mkDefault true;
    defaultEditor = mkDefault true;
    viAlias = mkDefault true;
    vimAlias = mkDefault true;
  };

  documentation.dev.enable = mkDefault true;

  environment.systemPackages = attrValues {
    inherit (pkgs)
      bat
      coreutils
      curl
      exa
      fd
      file
      p7zip
      pciutils
      restic
      rsync
      jq
      ripgrep
      strace
      tmux
      usbutils
      wget
      ;
  };

  environment.shellAliases = {
    cat = "bat --theme=gruvbox-dark";
    ls = "exa --git";
  };
}
