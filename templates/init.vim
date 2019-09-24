" =============================================================================
" Dependencies
" =============================================================================

filetype off                  " required
call plug#begin('~/.local/share/nvim/plugged')

" Enhancments
Plug 'editorconfig/editorconfig-vim'
Plug 'christoomey/vim-tmux-navigator'

" Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'

" Utils
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'

" Writing
Plug 'reedes/vim-pencil', {'for': 'markdown'}
Plug 'godlygeek/tabular', {'for': 'markdown'}

" Languages
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'benekastah/neomake'

Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript'}
Plug 'saltstack/salt-vim', {'for': 'sls'}
Plug 'ElmCast/elm-vim', {'for': 'elm'}
Plug 'raichoo/purescript-vim', {'for': 'purescript'}
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'dag/vim-fish', {'for': 'fish'}
Plug 'kchmck/vim-coffee-script', {'for': 'coffeescript'}
Plug 'lcolaholicl/vim-v', {'for': 'v'}

call plug#end()
filetype plugin indent on     " required

" =============================================================================
" CUSTOM
" =============================================================================

set backspace=2
set clipboard=unnamedplus
set colorcolumn=120
set nohlsearch
set nowrap
set termguicolors
set autoread
set number
set autowrite
set tabstop=2
set expandtab
set shiftwidth=2
set autoindent
set smartindent

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

let g:tmux_navigator_save_on_switch = 1
let g:deoplete#enable_at_startup = 1
let g:elm_format_autosave = 1
let g:airline#extensions#tabline#enabled = 1
let g:jsx_ext_required = 0
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

if executable('eslint')
  let g:neomake_javascript_enabled_makers = ['eslint']
endif

if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

nmap <Tab> :bn<cr>
nmap <S-Tab> :bp<cr>
nmap <C-X> :bd!<cr>

nmap <C-P> :FZF<cr>
nmap <C-F> :Buffers<cr>
nmap <C-S> :Ag<cr>
nmap <C-B> :BLines<cr>

tnoremap <C-c> <C-\><C-n>

" FIXME:
" https://github.com/christoomey/vim-tmux-navigator#it-doesnt-work-in-neovim-specifically-c-h
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>

" remove trailing whitespace on save
autocmd! BufWritePre * %s/\s\+$//e

autocmd! BufWritePost * Neomake
