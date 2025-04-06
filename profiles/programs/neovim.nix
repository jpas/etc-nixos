{ lib, config, pkgs, ... }:

with lib;

let
  wrapNeovim = cfg:
    let config = pkgs.neovimUtils.makeNeovimConfig cfg; in
    pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped
      (config // { wrapperArgs = escapeShellArgs config.wrapperArgs; });

  neovim = wrapNeovim {
    viAlias = true;
    vimAlias = true;

    customRC = ''
      set guicursor=
      set encoding=utf-8
      set fileencoding=utf-8
      set colorcolumn=80
      set number
      set nowrap
      set list
      set smartcase
      set nobackup nowritebackup
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = gruvbox;
        # FIXME: https://github.com/nix-community/home-manager/pull/1945
        config = ''
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
in
{
  environment = {
    systemPackages = [ neovim ];
    variables = {
      EDITOR = mkOverride 900 "nvim";
      VISUAL = mkOverride 900 "nvim";
    };
  };
}
