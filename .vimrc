" ============================================================
"  .vimrc — FZF-powered IDE-like Vim setup
"  Plugin manager: vim-plug (consolidated from Vundle)
"
"  First time setup:
"    1. Install vim-plug:
"       curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"    2. Open vim and run :PlugInstall
"          
"   NERDTree shortcuts
"          Space + f to fuzzy find files
"          Space + / to search inside files
"          Space + e to toggle the NERDTree sidebar
"          Space + b to switch buffers
"
"  Recommended external tools:
"    - fzf        : brew install fzf
"    - ripgrep    : brew install ripgrep
"    - bat        : brew install bat  (syntax-highlighted previews)
"    - fd         : brew install fd   (faster file finding)
" ============================================================


" ────────────────────────────────────────────────────────────
"  PLUGINS (vim-plug)
" ────────────────────────────────────────────────────────────
call plug#begin('~/.vim/plugged')

  " FZF — fuzzy finder core + vim commands
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " File tree sidebar
  Plug 'preservim/nerdtree'

  " Git integration
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'

  " Terraform syntax
  Plug 'hashivim/vim-terraform'

  " Ruby
  Plug 'vim-ruby/vim-ruby'
  Plug 'tpope/vim-rails'

  " Sparkup (zen-coding for HTML)
  Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

  " Rosé Pine Moon — easy on astigmatism eyes
  Plug 'rose-pine/vim', { 'as': 'rose-pine' }

  " Status bar (lightweight Powerline alternative — uncomment to enable)
  " Plug 'itchyny/lightline.vim'

call plug#end()


" ────────────────────────────────────────────────────────────
"  GENERAL SETTINGS
" ────────────────────────────────────────────────────────────
set nocompatible
filetype plugin indent on
syntax enable

set number                  " Line numbers
set relativenumber          " Relative line numbers (great for motions)
set ruler
set cursorline              " Highlight current line
set signcolumn=yes          " Always show sign column (avoids jitter)
set laststatus=2            " Always show status bar
set wildmenu                " Enhanced command-line completion
set hidden                  " Allow switching buffers without saving
set updatetime=300
set shortmess+=c

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

" Indentation
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent

" Splits open in a more natural direction
set splitright
set splitbelow

" Encoding
set encoding=utf-8

" Markdown filetype
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc

" Use ripgrep as grep if available
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif


" ────────────────────────────────────────────────────────────
"  FZF — CORE CONFIGURATION
" ────────────────────────────────────────────────────────────

" Use fd or rg for file finding (faster, respects .gitignore)
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
elseif executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git"'
endif

" Preview window on the right, 60% width (toggle with ctrl-/)
let g:fzf_preview_window = ['right:60%', 'ctrl-/']

" Floating window layout
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8, 'relative': v:true } }

" Match FZF colors to colorscheme
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


" ────────────────────────────────────────────────────────────
"  FZF — KEYBINDINGS (IDE-style)
" ────────────────────────────────────────────────────────────
let mapleader = " "

" File finding
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :GFiles<CR>
nnoremap <leader>g :GFiles?<CR>

" Search content
nnoremap <leader>/ :Rg<CR>
nnoremap <leader>* :Rg <C-R><C-W><CR>

" Buffers & history
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>H :History:<CR>
nnoremap <leader>S :History/<CR>

" In-file navigation
nnoremap <leader>l :BLines<CR>
nnoremap <leader>L :Lines<CR>
nnoremap <leader>t :BTags<CR>
nnoremap <leader>T :Tags<CR>

" Vim internals
nnoremap <leader>c :Commands<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader>k :Maps<CR>
nnoremap <leader>w :Windows<CR>

" Advanced grep with preview
command! -bang -nargs=* RgPreview
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}),
  \   <bang>0)

nnoremap <leader>R :RgPreview<CR>


" ────────────────────────────────────────────────────────────
"  NERDTREE
" ────────────────────────────────────────────────────────────
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>

autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
  \ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let NERDTreeShowHidden = 1
let NERDTreeMinimalUI  = 1


" ────────────────────────────────────────────────────────────
"  SPLIT & BUFFER NAVIGATION
" ────────────────────────────────────────────────────────────
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <Tab>   :bnext<CR>
nnoremap <S-Tab> :bprev<CR>
nnoremap <leader>x :bd<CR>


" ────────────────────────────────────────────────────────────
"  MISC QUALITY-OF-LIFE
" ────────────────────────────────────────────────────────────
nnoremap <Esc> :nohlsearch<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>` :terminal<CR>


" ────────────────────────────────────────────────────────────
"  ROSÉ PINE MOON — Colorscheme
"  Warm muted tones, reduced halation, easy on astigmatism
" ────────────────────────────────────────────────────────────
set background=dark

let g:rose_pine_variant = 'moon'
let g:rose_pine_disable_italics = 1  " Set to 1 if italics look blurry

colorscheme rosepine_moon

" Optional: uncomment to soften contrast further
highlight Normal     guibg=#1a1a2e guifg=#e0def4
highlight LineNr     guifg=#3b3a52
highlight CursorLine guibg=#2a2a3e

" ────────────────────────────────────────────────────────────
"  FOLDING (Ruby methods/classes)
" ────────────────────────────────────────────────────────────
set foldmethod=syntax       " Fold based on syntax
set foldlevelstart=99        " Files open with top-level folds open
set foldnestmax=3           " Don't fold more than 3 levels deep

" Only enable folding for Ruby files
autocmd FileType ruby setlocal foldmethod=syntax
autocmd VimEnter * NERDTree | wincmd p

" Handy fold keybindings
" za  → toggle fold under cursor
" zR  → open all folds
" zM  → close all folds
" zo  → open fold
" zc  → close fold

" Toggle only the innermost fold (method/block scope) with Enter
