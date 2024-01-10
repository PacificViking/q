{ config, pkgs, settings, ... }:
let
  rose-pine = pkgs.vimUtils.buildVimPlugin {
    name = "rose-pine";
    src = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "neovim";
      rev = "67b03139fe43f1fcd03cb34620ec3d41eb407793";
      hash = "sha256-TebsOqFF5bgkRddgz3viaMQXAagM0c0depkLXr0BcNU=";
    };
  };
in
{
  home.packages = with pkgs; [
    fzf
    code-minimap
    tree-sitter
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
      #semshi
      python-syntax
      #vim-gitgutter
      gitsigns-nvim
      iron-nvim
      vim-visual-multi
      vim-repeat
      suda-vim
      vim-git
      nerdtree
      nord-nvim
      material-vim
      gruvbox
      nerdcommenter
      tagbar
      vim-fugitive
      nvim-treesitter.withAllGrammars

      coc-nvim
      coc-rust-analyzer
      coc-pyright
      jsonc-vim

      colorbuddy-nvim
      material-nvim
      nightfox-nvim

      vim-devicons
    ] ++ [
      rose-pine
    ];
  };
}
