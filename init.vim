set t_Co=256
set encoding=utf8
set fileencoding=utf-8
set history=10000
set showcmd
set nojoinspaces
set incsearch
set hlsearch
set wrapscan
set shiftround
set infercase
set virtualedit=all
set hidden
set switchbuf=useopen
set showmatch
set matchtime=3
set backspace=indent,eol,start
set nowritebackup
set nobackup
set noswapfile
set list
set listchars=tab:\ \ 
set number
set wrap
set nrformats=
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set textwidth=0
set colorcolumn=100
set novisualbell
set nocompatible
set ignorecase
set smartcase
set autoindent
set autowrite
set smartindent
set ambiwidth=double
set laststatus=2
set statusline=%f
set statusline+=%=
set statusline+=[LOW=%l/%L]

inoremap <silent> jj <ESC>
nmap <Esc><Esc> :nohl<CR>
imap <C-j> <esc><jis_eissuu>
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

nnoremap k gk
nnoremap j gj
nnoremap & :&&<CR>
nnoremap ; :
nnoremap : ;
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap <silent> bv :bprevious<CR>
nnoremap <silent> bn :bnext<CR>
nnoremap <silent> bd :bdelete<CR>

noremap <Leader>n nzz
noremap <Leader>N Nzz
nnoremap sr <C-w>r
nnoremap sw <C-w>w
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
vnoremap v $h
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
xnoremap & :&&<CR>

let s:dein_config_dir =$XDG_CONFIG_HOME . '/nvim'
let s:dein_cache_dir  =$XDG_CACHE_HOME  . '/dein'

"dein start---------------------------
if &compatible
  set nocompatible
endif

set runtimepath +=$XDG_CACHE_HOME/dein/repos/github.com/Shougo/dein.vim

if dein#load_state(s:dein_cache_dir)
  call dein#begin(s:dein_cache_dir)

  call dein#load_toml(s:dein_config_dir . '/dein.toml', {'lazy': 0})
  call dein#load_toml(s:dein_config_dir . '/dein_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable
"dein end-----------------------------

autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none

autocmd InsertLeave * set nopaste

colorscheme onedark
let g:airline_theme='oceanicnext'
