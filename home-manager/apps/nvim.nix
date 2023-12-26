{ config, pkgs, settings, ... }:
{
  home.packages = with pkgs; [
    fzf
    code-minimap
  ];
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/nvim";

  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      undotree
      fzfWrapper
      vim-easymotion
      incsearch-vim
      incsearch-easymotion-vim
      lightline-vim
      minimap-vim
      vim-peekaboo
      indentLine
      webapi-vim
      auto-pairs
      hop-nvim
      vim-which-key
      semshi
      vim-gitgutter
      iron-nvim
      vim-visual-multi
      vim-repeat
      suda-vim
      vim-git
      nerdtree
      nord-vim
      material-vim
      gruvbox
      nerdcommenter
      tagbar
      vim-fugitive
      nvim-treesitter.withAllGrammars
      # (fromGitHub "HEAD" "elihunter173/dirbuf.nvim")
      coc-nvim
      coc-rust-analyzer
      jsonc-vim
      rose-pine

      vim-devicons
    ];
  };
}
