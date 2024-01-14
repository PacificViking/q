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
    lua-language-server
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
      lualine-nvim
      lualine-lsp-progress
      mini-nvim
      vim-peekaboo
      indentLine
      
      nvim-hlslens
      nvim-scrollbar
      nvim-autopairs
      hop-nvim
      flash-nvim
      which-key-nvim
      gitsigns-nvim
      vim-visual-multi
      vim-repeat
      suda-vim
      nvim-tree-lua
      comment-nvim
      nvim-treesitter.withAllGrammars
      nvim-lastplace
      lsp_signature-nvim
      markdown-preview-nvim

      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-zsh
      cmp-git
      ultisnips
      cmp-nvim-ultisnips
      cmp-nvim-lsp-signature-help

      colorbuddy-nvim
      material-nvim
      nightfox-nvim
      nord-nvim
      material-vim
      gruvbox

      nvim-web-devicons
    ] ++ [
      rose-pine
    ];
  };
}
