" ================================
" Neovim Configuration - init.vim
" ================================

" Ensure vim-plug is loaded
call plug#begin('~/.vim/plugged')

" Plugins for Neovim
Plug 'junegunn/fzf.vim'               " Fuzzy file search
Plug 'tpope/vim-sensible'             " Sensible defaults
Plug 'hrsh7th/nvim-cmp'              " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp'          " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'            " Buffer source for nvim-cmp
Plug 'hrsh7th/cmp-path'              " Path source for nvim-cmp
Plug 'nvim-treesitter/nvim-treesitter' " Treesitter for better syntax highlighting
Plug 'vim-airline/vim-airline'       " Status bar with powerline
Plug 'vim-airline/vim-airline-themes' " Powerline Themes
Plug 'scrooloose/nerdtree'           " File explorer
Plug 'airblade/vim-gitgutter'        " Git status in the gutter
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Powerful autocompletion engine (Alternative to nvim-cmp)
Plug 'tpope/vim-fugitive'            " Git integration for Vim (corrected reference)
Plug 'preservim/nerdcommenter'      " Easy commenting
Plug 'neovim/nvim-lspconfig'

" End plugin section
call plug#end()

" ================================
" General Settings
" ================================

" Enable clipboard support (allows copy/paste between Neovim and other applications)
set clipboard=unnamedplus

" Enable line numbers
set number

" Enable relative line numbers
set relativenumber

" Set background to dark for better colors
set background=dark

" Enable syntax highlighting
syntax enable

" Enable line wrapping
set wrap

" Auto-indentation
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Enable 24-bit RGB colors
set termguicolors

" Highlight search matches as you type
set incsearch
set hlsearch

" ================================
" LSP and Completion Setup
" ================================
" Ensure plugin installation before LSP setup
if !exists('g:vscode')
    " Wait for plugins to load
    autocmd VimEnter * lua vim.defer_fn(function() require('lsp-config').setup() end, 100)
endif

" Auto-completion settings
set completeopt=menu,menuone,noselect
let g:cmp_active = 1

" Check if node is installed for COC
if executable('node')
  " COC is ready to use
else
  echohl WarningMsg
  echo "Warning: Node.js is not installed. COC will not work properly."
  echo "Please install Node.js from https://nodejs.org/en/download/"
  echohl None
endif

" ================================
" Keybindings
" ================================
" Keymap to open NERDTree
nnoremap <Leader>n :NERDTreeToggle<CR>

" Keymap to start FZF file search
nnoremap <Leader>f :Files<CR>

" ================================
" Airline Status Bar
" ================================

" Enable airline status bar
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='dark' 

" ================================
" Git Integration
" ================================

" Show git status in the sign column
let g:gitgutter_enabled = 1

" ================================
" Miscellaneous Settings
" ================================

" Always display the cursor line
set cursorline

" Enable auto-wrapping of long lines
set textwidth=80

" Show matching parentheses and brackets
set showmatch

" ================================
" Filetype Specific Settings
" ================================

" Enable Python-specific settings
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4

" ================================
" Update Plugins Automatically
" ================================

" Install and update plugins on startup
"autocmd VimEnter * PlugInstall --sync | source $MYVIMRC

" ================================
" End of init.vim
" ================================


