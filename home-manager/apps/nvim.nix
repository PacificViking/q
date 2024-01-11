{ config, pkgs, settings, masterpkgs, ... }:
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
    python311Packages.python-lsp-server
    python311Packages.pyls-isort
    python311Packages.python-lsp-black
    python311Packages.pyls-memestra
    python311Packages.pylsp-rope
    python311Packages.python-lsp-ruff
    pyright
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
      nvim-lspconfig

      undotree
      fzf-lua
      #incsearch-vim
      # lightline-vim
      # minimap-vim
      lualine-nvim
      lualine-lsp-progress
      mini-nvim
      vim-peekaboo
      indentLine

      nvim-hlslens
      nvim-scrollbar
      # webapi-vim
      # auto-pairs
      nvim-autopairs
      hop-nvim
      flash-nvim
      which-key-nvim
      # semshi
      # python-syntax
      gitsigns-nvim
      # iron-nvim
      vim-visual-multi
      vim-repeat
      suda-vim
      # vim-git
      # nerdtree
      nvim-tree-lua
      comment-nvim
      # tagbar
      # vim-fugitive
      nvim-treesitter.withAllGrammars
      nvim-lastplace

      # jsonc-vim

      colorbuddy-nvim
      material-nvim
      nightfox-nvim
      nord-nvim
      material-vim
      gruvbox

      # vim-devicons
      nvim-web-devicons
    ] ++ [
      rose-pine
    ];
  };
}
