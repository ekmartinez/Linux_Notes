" Location: ~/.config/nvim

:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set completeopt-=preview " For No Preview

" install vim-plug
call plug#begin()

Plug 'https://github.com/tpope/vim-surround' " Surroundings (ysw)
Plug 'https://github.com/vim-airline/vim-airline' "Status Bar
Plug 'https://github.com/preservim/nerdtree' "Navigation
Plug 'https://github.com/tpope/vim-Commentary' "For Commenting gcc & gc
Plug 'https://github.com/ap/vim-css-color' "CSS Color Preview
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'voldikss/vim-floaterm'
" Plug 'https://github.com/tc50cal/vim-terminal' "Vim Terminal
Plug 'https://github.com/preservim/tagbar' " Tagbar for navigation
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " For other color schemes configurations.
Plug 'https://github.com/neoclide/coc.nvim' " Auto Completion
Plug 'https://github.com/terryma/vim-multiple-cursors' "CTRL + N for multiple cursors

call plug#end()

" :set colorscheme jellybeans

"Press F8 for Tagbar which shows variables navigation
nmap <F8> :TagbarToggle<CR> 

" Adds characters Expand and Collapse characters.
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

nnoremap <C-f> :NERDTreeFocus<CR>    "Ctrl + f
nnoremap <C-n> :NERDTree<CR>         "Ctrl + n
nnoremap <C-t> :NERDTreeToggle<CR>   "Ctrl + t

" Selects option from coc autocompletion
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

" COC - Conquer of Completion
" --------------------------------------------------------------
" Plug 'https://github.com/neoclide/coc.nvim' " Auto Completion
" Install nodejs and npm
" Navigate to plugged directory (where all the pluggins are installed)
" cd coc.nvim
" sudo npm install -g yarn
" yarn install
" yarn build
" :CocInstall coc-python (completions for python)
" pip install jedi
"
"Instructions for C compeletions (Tested on Ubuntu Server 22)
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"sudo apt-get install clangd-12 (install latest version, change 12 accordingly)
"In vim: :CocInstall coc-clangd
"if coc-clangd - if error when opening C file, try :CocCommand clangd.install
"-------------------------------------------------------------------
"
" Vim Terminal (Does not work on Fedora Silverblue Toolbox)
" Try Floaterm instead.
" :TerminalSplit bash
"
"ysw sorroundings
"In normal mode type: ysw followed by the character ex:
"ysw( -> this will include the clossing parenthesis.
"
"" :PlugInstall = Installs Pluggin
" :PlugClean = Deletes Pluggin
" :UpdateRemotePlugins

" Floaterm
" Use :FloatermNew to open a terminal window, use :FloatermToggle to hide/reopen that. 
" The filetype of the terminal buffer is floaterm.

"Thanks NeuralNine.
