{ pkgs
, ... 
}:
{
  programs.neovim.extraConfig = ''
    source $HOME/.config/nvim/init.local.vim
  '';
}
