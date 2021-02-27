{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      if &term != "linux"
        set termguicolors
      endif

      set guicursor=
      set encoding=utf-8
      set fileencoding=utf-8
      set colorcolumn=80
      set number
      set nowrap
      set list
      set smartcase

      syntax on
      syntax sync minlines=500
    '';

    plugins = with pkgs.vimPlugins; [
      {
        plugin = gruvbox;
        config = ''
          colorscheme gruvbox

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
