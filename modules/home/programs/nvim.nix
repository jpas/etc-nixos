{ ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  home.sessionVariables = {
    VISUAL = "vim";
    EDITOR = "vim";
  };

  programs.bash.shellAliases = { vim = "vim -p"; };
}
