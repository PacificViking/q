"turn on syntax
syntax on
set ignorecase  "ignore case
"autocmd to restore last cursor position 
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"remove highlight when pressing esc
map <esc> :noh <CR>
"exit insert mode with kj
inoremap kj <esc>
inoremap jk <esc>
vnoremap mn <esc>
"automatic line numbers
set number
"dont allow hiding buffer if its not done
set nohid
"add command autocomplete
set wmnu
"no error bell
set noeb
"less lag
set updatetime=300
"underline matching parenthesis
hi MatchParen cterm=underline,bold ctermbg=none ctermfg=blue
"don't need to show mode anymoe because lightline
set noshowmode
"persistent undo
set undofile
set undodir=~/.vim/undodir

"for rust?
syntax enable
filetype on
filetype plugin on
filetype plugin indent on

"shortcut for window
noremap e <C-w>
"quick up down scroll
nnoremap <Up> 15<C-y>
nnoremap <Down> 15<C-e>
vnoremap <Up> 15<C-y>
vnoremap <Down> 15<C-e>

"scroll in visual mode with +=
vnoremap = <C-y><C-y><C-y><C-y><C-y>
vnoremap - <C-e><C-e><C-e><C-e><C-e>
nnoremap = <C-y><C-y><C-y><C-y><C-y>
nnoremap - <C-e><C-e><C-e><C-e><C-e>

vnoremap <leader>id =
nnoremap <leader>id =

"fast scrolling
noremap H ^
noremap J jjj
noremap K kkk
noremap L $

"better jump list navigation
noremap ( <C-o>
noremap ) <C-i>

"delete without erasingk
nnoremap d- O<esc>jddk

"go (to) other (parenthesis)
noremap go %

"operator pending use l and h to select all forwards and backwards
onoremap l $
onoremap h ^

" Allow saving of files as sudo when I forgot to start vim using sudo.
"cmap w!! w !sudo tee > /dev/null %
command W :SudaWrite

"filetype plugins
filetype plugin on
filetype plugin indent on

"don't conceal json
autocmd Filetype json,dockerfile
  \ let g:indentLine_setConceal = 0 |
  \ let g:vim_json_syntax_conceal = 0 |
  \ let g:vim_dockerfile_syntax_conceal = 0 |
  \ set conceallevel=0

"easy configure initvim
"don't use :e because :tabnew takes argument
command Ivim :tabnew ~/dotconf/nvim/init.vim
"command Ivim :tabnew ~/.config/nvim/init.vim
"command Bash :tabnew ~/.bash_profile
"command Prof :tabnew ~/.profile
command Cocc :tabnew ~/dotconf/nvim/coc.vim
"command Zshrc :tabnew ~/.zshrc
"command Javahi :tabnew ~/.config/nvim/syntax/java.vim
"command Hconf :tabnew ~/.config/home-manager/home.nix
"command Irc :tabnew ~/.initrc
"command Mime :tabnew ~/.config/mimeapps.list
"automatically reload vim after editing
"autocmd BufWinLeave init.vim source ~/init.vim

"set true colors
" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
	let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

" For Neovim > 0.1.5 and Vim > patch 7.4.1799 - https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162
" Based on Vim patch 7.4.1770 (`guicolors` option) - https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd
" https://github.com/neovim/neovim/wiki/Following-HEAD#20160511
if (has('termguicolors'))
  set termguicolors
endif

"mouse defaults
"set mouse=a
function! ToggleMouse()
    " check if mouse is enabled
    if &mouse == 'a'
        " disable mouse
        set mouse=
    else
        " enable mouse everywhere
        set mouse=a
    endif
endfunc
noremap <C-x> :call ToggleMouse()<CR>

"jenkinsfile highlight
au BufNewFile,BufRead Jenkinsfile setf groovy


"alefixers
let b:ale_fixers = {'python': ['black', 'autopep8', 'autoflake', 'reorder-python-imports', 'yapf', 'remove_trailing_lines', 'trim_whitespace']}
"let b:ale_fixers = {'python': ['black']}
""nmap <F5> :ALEToggleBuffer<CR>
"let b:ale_enabled = 0
"nmap <F5> :ALEToggle()<CR>
""autocmd FileType * ALEDisableBuffer

"asdfasdf
"filetype syntax highlighting
"highlight etc environment properly
au BufReadPost /etc/environment set syntax=sh
au BufReadPost ~/.initrc set syntax=sh
au BufReadPost *.conf set filetype=config
au BufReadPost config set filetype=jsonc

function! DefaultConfHi()
	if !exists("b:current_syntax")
		set syntax=c
	endif
endfunc
au BufReadPost ~/.config/* call DefaultConfHi()

"prettier tabs
autocmd FileType * set tabstop=4 shiftwidth=0
" https://stackoverflow.com/questions/51995128/setting-autoindentation-to-spaces-in-neovim

" set indent tabs to spaces
autocmd FileType nix set expandtab shiftwidth=2
autocmd FileType javascript set expandtab shiftwidth=4

"deoplete autocomplete fast
"call deoplete#custom#option('candidate_marks',
"                      \ ['!', '@', '#', '$', '%'])
"                inoremap <expr>!       pumvisible() ?
"                \ deoplete#insert_candidate(0) : '!'
"                inoremap <expr>@       pumvisible() ?
"                \ deoplete#insert_candidate(1) : '@'
"                inoremap <expr>#       pumvisible() ?
"                \ deoplete#insert_candidate(2) : '#'
"                inoremap <expr>$       pumvisible() ?
"                \ deoplete#insert_candidate(3) : '$'
"                inoremap <expr>%       pumvisible() ?
"                \ deoplete#insert_candidate(4) : '%'

"autopairs and deoplete toggle on esc
let g:AutoPairsShortcutToggle = '<leader><leader>p'

let g:AutoPairs={'{':'}'}

"redo with U
nnoremap U <C-r>

"undotree
nnoremap * :UndotreeToggle<CR>

"let b:coc_suggest_disable = 1
function! CocSuggestToggle()
	if b:coc_suggest_disable == 0
		let b:coc_suggest_disable = 1
	elseif b:coc_suggest_disable == 1
		let b:coc_suggest_disable = 0
	endif
endfunc
function! CocSuggestEnable()
	let b:coc_suggest_disable = 0
endfunc

inoremap Ω <esc>:call CocSuggestToggle()<CR>a
autocmd InsertLeave * call CocSuggestEnable()

"gitgutter
nmap g] <Plug>(GitGutterNextHunk)
nmap g[ <Plug>(GitGutterPrevHunk)
nmap g\ <Plug>(GitGutterPreviewHunk)

"autocmd FileType * call AutoPairsDisable()
"autocmd FileType python,vim,rust call AutoPairsDisable()
autocmd FileType java call AutoPairsEnable()

"indentline config
"let g:indentLine_char = ':'
"let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_color_gui = '#434c5e'

"automatic tagbar
let g:tagbar_width=30
nmap <silent> <F4> :TagbarToggle<CR>
"autocmd VimEnter * TagbarStart | wincmd p
let g:tagbar_position='topleft vertical'

nmap <F3> <Plug>ToggleMarkbar

"find syntax highlight under cursor
"https://vim.fandom.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" html folds
autocmd FileType html set foldmethod=indent
autocmd FileType html normal zR

"automatic folding and spacebar unfolding
"autocmd filetype python setlocal foldmethod=indent
"autocmd filetype python setlocal foldlevel=99
nnoremap <space> za
"this ^ might cause problems, use noremap if causes problems
nmap 3# i-----  -----<esc><Plug>NERDCommenterCommentBhi

"failed attempt, I lost to my sideebars
"function Numsidebar()
"        let g:sidebars = 0
"        if exists('b:NERDTree') && b:NERDTree.isTabTree()
"                call append(0, 'asdf')
"                let g:sidebars += 1
"        endif
"        if exists('b:tagbar') && b:tagbar.IsOpen()
"                call append(1, 'bsdf')
"                let g:sidebars += 1
"        endif
"        if exists('b:minimap')
"                call append(2, 'csdf')
"                let g:sidebars += 1
"        endif
"endfunction
"
"autocmd BufEnter * call Numsidebar() | if winnr('$') <= g:sidebars| quitall | endif
"
"
"use nord colorscheme
"colorscheme gruvbox
"set background=dark
"colorscheme material
"use colorscheme on lightline
"let g:lightline = { 'colorscheme': 'gruvbox'}
let g:lightline = { 'colorscheme': 'rosepine_moon'}
"custom semshi highlights
"includes minimap highlights
function MyCustomHighlights()
	hi Normal guifg=#eceff4
	hi semshiLocal           ctermfg=209 guifg=#d08770
	hi semshiGlobal          ctermfg=214 guifg=#8fbcbb
	hi semshiImported        ctermfg=214 guifg=#ebcb8b cterm=bold gui=bold
	hi semshiParameter       ctermfg=75  guifg=#81a1c1
	hi semshiParameterUnused ctermfg=117 guifg=#88c0d0 cterm=underline gui=underline
	hi semshiFree            ctermfg=218 guifg=#e5e9f0
	hi semshiBuiltin         ctermfg=207 guifg=#b48ead
	hi semshiAttribute       ctermfg=49  guifg=#5e81ac
	hi semshiSelf            ctermfg=249 guifg=#e5e9f0
	hi semshiUnresolved      ctermfg=226 guifg=#bf616a cterm=underline gui=underline
	hi semshiSelected        ctermfg=231 guifg=#eceff4 ctermbg=161 guibg=#4c566a

	hi semshiErrorSign       ctermfg=231 guifg=#eceff4 ctermbg=160 guibg=#bf616a
	hi semshiErrorChar       ctermfg=231 guifg=#eceff4 ctermbg=160 guibg=#bf616a
	sign define semshiError text=E texthl=semshiErrorSign

	hi minimapCursor guifg=#d8dee9 cterm=bold
	"hi Search guifg=#88c0d0 guibg=#bf616a

	hi tagbarHighlight guifg=#d8dee9 cterm=bold
endfunction
"autocmd FileType python call MyCustomHighlights()

"let g:python_highlight_all = 1

"highlights for search results
hi IncSearch guifg=#d8dee9 guibg=#5e81ac
hi Search guifg=#d8dee9 guibg=#5e81ac
hi IncSearchMatch guifg=#d8dee9 guibg=#5e81ac
hi IncSearchOnCursor guifg=#d8dee9 guibg=#5e81ac

"enable deoplete at startup
let g:deoplete#enable_at_startup = 1

"update semshi because easymotion changes stuff
"let g:semshi#always_update_all_highlights = v:true
"semshi different highlight for selected
"hi semshiSelected cterm=bold ctermbg=none ctermfg=none

"open nerdtree automatically
autocmd VimEnter * NERDTree | wincmd p
nnoremap <Leader>a :NERDTreeToggle \| MinimapToggle<CR><C-w>l
" Close the tab if NERDTree and tagbar are there
"autocmd BufEnter * if winnr('$') <= 2 && exists('b:NERDTree') && b:NERDTree.isTabTree() && exists('b:tagbar') && b:tagbar.IsOpen() | quit | endif
"autocmd BufEnter * if winnr('$') <= 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
"autocmd BufEnter * if winnr('$') <= 1 && exists('b:tagbar') && b:tagbar.IsOpen() | quit | endif
let NERDTreeMapOpenExpl='q'
let NERDTreeMapQuit='\q'

"automatically save and enter view
"autocmd BufWinLeave *.* mkview
"autocmd BufWinEnter *.* silent loadview 
"

lua <<EOF
require('gitsigns').setup()

require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  -- don't because nix
  -- ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    --disabled languages
    -- disable = {"python", "java", "vim"},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- disable italics for neovim rose pine
require('rose-pine').setup({
    disable_italics = true,
    styles = {
      bold = true,
      italic = false,
      transparency = false
    },

    highlight_groups = {
       Comment = { italic = true }
    }
})

EOF

colorscheme rose-pine-moon

"syntastic stuff
function Startsyntastic()
	set statusline+=%#warningmsg#
	set statusline+=%{SyntasticStatuslineFlag()}
	set statusline+=%*

	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0
endfunction
autocmd FileType rust call Startsyntastic()

"highlight wrong comments (the ones that use # and not ")
"au FileType vim syntax match hashCommentWrong /#*\n/
"highlight HashCommentWrong ctermbg=red

"vim minimap for code browsing
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1

"fzf vim mappings
noremap ff :Files<CR>
noremap fb :Buffers<CR>
noremap fl :BLines<CR>
noremap fa :Ag<CR>
noremap fL :Lines<CR>
noremap ft :BTags<CR>
noremap fT :Tags<CR>
noremap fm :CocCommand fzf-preview.Marks<CR>
noremap fM :Marks<CR?
noremap fw :Windows<CR>
noremap fh :History<CR>
noremap fc :History:<CR>
noremap fs :History/<CR>
noremap fo :BCommits<CR>
noremap fO :Commits<CR>

" Mapping selecting mappings
nmap <leader><tab> <Plug>(fzf-maps-n)
xmap <leader><tab> <Plug>(fzf-maps-x)
omap <leader><tab> <Plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <Plug>(fzf-complete-word)
imap <c-x><c-f> <Plug>(fzf-complete-path)
imap <c-x><c-l> <Plug>(fzf-complete-line)

"easy management of tabs with t
nnoremap ta :tabnew<CR>
nnoremap tn :tabnew<CR>
nnoremap td :tabclose<CR>
nnoremap th gT
nnoremap tl gt

"incsearch no highlight
"noremap /  :set hlsearch<CR><Plug>(incsearch-forward)
"noremap ?  :set hlsearch<CR><Plug>(incsearch-backward)
"noremap g/ :set hlsearch<CR><Plug>(incsearch-stay)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/  <Plug>(incsearch-stay)
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map <Right>  <Plug>(incsearch-nohl-n)
map <Left>  <Plug>(incsearch-nohl-N)
"map *  <Plug>(incsearch-nohl-*)
"noremap #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"easymotion search and go
"map ss :set nohlsearch <CR> <Plug>(easymotion-sn)
"omap ss :set nohlsearch <CR> <Plug>(easymotion-tn)
"map s :set nohlsearch <CR> <Plug>(easymotion-s2)
"omap s :set nohlsearch <CR> <Plug>(easymotion-t2)
map s <Plug>(easymotion-s2)
omap s <Plug>(easymotion-t2)
vmap s <Plug>(easymotion-t2)

"move display lines
noremap j gj
noremap k gk

"easymotion gl, gj, gk, gh
map gl <Plug>(easymotion-lineforward)
map gj <Plug>(easymotion-j)
map gk <Plug>(easymotion-k)
map gh <Plug>(easymotion-linebackward)
omap gl <Plug>(easymotion-lineforward)
omap gj <Plug>(easymotion-j)
omap gk <Plug>(easymotion-k)
omap gh <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_keys = 'sdfjklghzcvbnmweruioqa '

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> S incsearch#go(<SID>config_easyfuzzymotion())



"nerdcommenter use # to toggle whether comment or not
map # <Plug>NERDCommenterToggle
"don't put space after # in python
au FileType python let g:NERDSpaceDelims=0
"the default comment for python is #_ for some reason
let g:NERDCustomDelimiters = {'python': {'left': '#'}, 'config': {'left': '#'}}
let g:NERDDefaultAlign = 'left'
let g:NERDToggleCheckAllLines = 1
let g:NERDCommentEmptyLines = 1

nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

nmap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResourcesRpc project_mru git<CR>
nmap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatusRpc<CR>
nmap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActionsRpc<CR>
nmap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffersRpc<CR>
nmap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffersRpc<CR>
nmap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResourcesRpc buffer project_mru<CR>
nmap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumpsRpc<CR>
nmap <silent> [fzf-p]g;    :<C-u>FzfPreviewChangesRpc<CR>
nmap <silent> [fzf-p]/     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nmap <silent> [fzf-p]*     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nmap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrepRpc<Space>
xmap          [fzf-p]gr    "sy:FzfPreviewProjectGrepRpc<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nmap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTagsRpc<CR>
nmap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFixRpc<CR>
nmap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationListRpc<CR>

source ~/.config/nvim/coc.vim
