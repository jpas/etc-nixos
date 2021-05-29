{ pkgs
, ...
}:

{
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = gruvbox;
        # FIXME: https://github.com/nix-community/home-manager/pull/1945
        config = ''
          set guicursor=
          set encoding=utf-8
          set fileencoding=utf-8
          set colorcolumn=80
          set number
          set nowrap
          set list
          set smartcase
          set nobackup nowritebackup
        '' + ''
          if &term != "linux"
            set termguicolors
          endif
          colorscheme gruvbox
          syntax on
          syntax sync minlines=500
        '';
      }
      {
        plugin = lightline-vim;
        config = ''
          let g:lightline = { 'colorscheme': 'gruvbox' }
        '';
      }
      {
        plugin = fzf-vim;
        config = ''
          noremap <C-p> :FZF<cr>
        '';

        # TODO: change colours to work with gruvbox
      }
      pkgs.fzf
      supertab
      {
        plugin = vim-better-whitespace;
        config = ''
          let g:better_whitespace_ctermcolor=8
        '';
      }
      vim-commentary
      vim-dispatch
      vim-fugitive
      vim-gitgutter
      vim-polyglot
      vim-repeat
      vim-sensible
      vim-sleuth
      vim-surround
      vim-unimpaired
    ];
  };

  home.sessionVariables = {
    VISUAL = "vim";
    EDITOR = "vim";
  };

  programs.bash.shellAliases = { vim = "vim -p"; };
}
