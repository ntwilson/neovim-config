" Vim with all enhancements
" source $VIMRUNTIME/vimrc_example.vim

call plug#begin()
Plug 'phaazon/hop.nvim'
Plug 'tpope/vim-surround'
Plug 'BurntSushi/ripgrep'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'github/copilot.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'deoplete-plugins/deoplete-lsp'
Plug 'ionide/Ionide-vim'
Plug 'ncm2/float-preview.nvim'
call plug#end()


set splitbelow
set shell=pwsh
let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote=

let mapleader = ","
lua require("hop").setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }
lua <<EOF
require("toggleterm").setup{
  open_mapping = [[<c-a>]],
  start_in_insert = true,
  terminal_mappings = true,
  shell = "pwsh.exe"
}
require("telescope").load_extension "file_browser"
EOF
let g:deoplete#enable_at_startup = 1
set completeopt+=preview
" let g:python3_host_prog = '~/Miniconda/python3.exe'

map <Leader><Leader>w :HopWordAC<Enter>
map <Leader><Leader>b :HopWordBC<Enter>
map <Leader><Leader>j :HopLineAC<Enter>
map <Leader><Leader>k :HopLineBC<Enter>
map <Leader>a <cmd>ToggleTerm direction=horizontal<cr>
map <Leader>o <cmd>ToggleTerm direction=float<cr>

" Find files using Telescope command-line sugar
"
map <leader>ff <cmd>Telescope find_files<cr>
map <leader>fg <cmd>Telescope live_grep<cr>
map <leader>fb <cmd>Telescope buffers<cr>
map <leader>fh <cmd>Telescope help_tags<cr>
map <leader>fe <cmd>Telescope file_browser<cr>

map gh <cmd>lua vim.lsp.buf.hover()<cr>
map gd <cmd>lua vim.lsp.buf.definition()<cr>
map gs <cmd>lua vim.lsp.buf.signature_help()<cr>
map gD <cmd>lua vim.lsp.buf.type_definition()<cr>

set number
set ignorecase
set expandtab

set noswapfile
set noundofile
set nobackup
set belloff=all

set path=$PWD\**
set wildignore+=**\node_modules\**

" ~/.vim/vimrc
"
set exrc
set secure

set encoding=utf-8


" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction


" set guicursor=n-v-c:block-Cursor
" set guicursor+=i:ver25-iCursor
" set guicursor+=v:blinkon0

" Cursor in terminal
" https://vim.fandom.com/wiki/Configuring_the_cursor
" 1 or 0 -> blinking block
" 2 solid block
" 3 -> blinking underscore
" 4 solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar

" let &t_ti.="\e[1 q"
" let &t_SI.="\e[5 q"
" let &t_SR.="\e[4 q"
" let &t_EI.="\e[1 q"
" let &t_te.="\e[1 q"



