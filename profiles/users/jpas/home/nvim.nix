{ ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      source ''$HOME/.config/nvim/init.local.vim
    '';
  };

  home.sessionVariables = {
    VISUAL = "vim";
    EDITOR = "vim";
  };

  programs.bash.shellAliases = { vim = "vim -p"; };
}
