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
  rasmus = pkgs.vimUtils.buildVimPlugin {
    name = "rasmus";
    src = pkgs.fetchFromGitHub {
      owner = "kvrohit";
      repo = "rasmus.nvim";
      rev = "f824de95d446686e479781c0c2b778c177da528f";
      hash = "sha256-KrONLw++ITBP5YKDlRiaHqCHKlbjDlECcERB0fQeBc0=";
    };
  };

  neovimFixedWrapper = pkgs.neovim-unwrapped.overrideAttrs (old: {
    # name = "neovimFixedWrapper";
    postInstall = ''
      ${pkgs.gnused}/bin/sed -i 's/Exec=nvim %F/Exec=alacritty -e nvim %F/g' $out/share/applications/nvim.desktop
      ${pkgs.gnused}/bin/sed -i 's/Terminal=true/Terminal=false/g' $out/share/applications/nvim.desktop
    '';
  });

in
{
  home.packages = with pkgs; [
    alacritty

    fzf
    code-minimap
    tree-sitter
    python312Packages.python-lsp-server
    python312Packages.pyls-isort
    # python312Packages.python-lsp-black
    python312Packages.pyls-memestra
    python312Packages.pylsp-rope
    python312Packages.python-lsp-ruff
    pyright
    lua-language-server
    marksman
    glow
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
      nvim-lsputils
      
      undotree
      fzf-lua
      lualine-nvim
      lualine-lsp-progress
      mini-nvim
      vim-peekaboo
      indent-blankline-nvim
      oil-nvim
      mini-nvim
      fzf-lua
      
      nvim-hlslens
      nvim-scrollbar
      nvim-autopairs
      hop-nvim
      flash-nvim
      which-key-nvim
      gitsigns-nvim
      vim-visual-multi
      vim-repeat
      vim-suda
      nvim-tree-lua
      comment-nvim
      nvim-treesitter.withAllGrammars
      # nvim-treesitter-parsers.markdown
      # nvim-treesitter-parsers.markdown_inline
      nvim-lastplace
      lsp_signature-nvim
      markdown-preview-nvim
      glow-nvim
      # vim-markdown

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
      dracula-nvim

      nvim-web-devicons
    ] ++ [
      rose-pine
      rasmus
      pkgs.vimPlugins.blink-cmp
    ];
    package = neovimFixedWrapper;
  };

}
