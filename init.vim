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
Plug 'nvim-tree/nvim-tree.lua'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'github/copilot.vim'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'deoplete-plugins/deoplete-lsp'
Plug 'jeetsukumaran/vim-indentwise'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'ionide/Ionide-vim'
Plug 'ncm2/float-preview.nvim'

Plug 'purescript-contrib/purescript-vim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'chrisbra/unicode.vim'

Plug 'kosayoda/nvim-lightbulb'
Plug 'antoinemadec/FixCursorHold.nvim'

" Plug 'nyoom-engineering/oxocarbon.nvim'
" Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
" Plug 'ellisonleao/gruvbox.nvim'
" Plug 'rktjmp/lush.nvim'
" Plug 'uloco/bluloco.nvim'
call plug#end()


set splitbelow

set number
set ignorecase
set tabstop=2
set shiftwidth=2
set expandtab
set autowriteall
set nowrap

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
colorscheme slate

if has("win32")
  set shell=pwsh
  let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
  let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  set shellquote= shellxquote=
endif

let mapleader = ","

set completeopt+=preview

map <Leader><Leader>w <cmd>HopWordAC<cr>
map <Leader><Leader>b <cmd>HopWordBC<cr>
map <Leader><Leader>j <cmd>HopLineAC<cr>
map <Leader><Leader>k <cmd>HopLineBC<cr>
map <Leader>tt <cmd>ToggleTerm direction=horizontal<cr>
map <Leader>to <cmd>ToggleTerm direction=float<cr>
nnoremap <leader>ts <cmd>ToggleTermSendCurrentLine 1<cr>
vnoremap <leader>ts <cmd>ToggleTermSendVisualSelection 1<cr>
tmap <esc> <C-\><C-n>
map <C-j> <C-w>j
map <C-k> <C-w>k
tmap <C-j> <C-\><C-n><C-w>j
tmap <C-k> <C-\><C-n><C-w>k

set updatetime=2000
au CursorHold * :update

" Find files using Telescope command-line sugar
"
map <leader>ff <cmd>Telescope find_files hidden=true<cr>
map <leader>fg <cmd>Telescope live_grep hidden=true<cr>
map <leader>fb <cmd>Telescope buffers hidden=true<cr>
map <leader>fh <cmd>Telescope help_tags hidden=true<cr>
map <leader>fe <cmd>Telescope file_browser hidden=true<cr>
map <leader>fd <cmd>NvimTreeToggle<cr>

map K <cmd>lua vim.lsp.buf.hover()<cr>
map gd <cmd>lua vim.lsp.buf.definition()<cr>

map gh <cmd>lua vim.lsp.buf.type_definition()<cr>
map gs <cmd>lua vim.lsp.buf.signature_help()<cr>
map <leader>. <cmd>lua vim.lsp.buf.code_action()<cr>
map <leader><leader>t <cmd>TroubleToggle<cr>
map <leader>s <cmd>tab split<cr>
map <leader>w <cmd>set wrap!<cr>

lua <<EOF

require("hop").setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }

require("toggleterm").setup{
  open_mapping = [[<c-t>]],
  start_in_insert = true,
  hide_numbers = true,
  terminal_mappings = true,
  shell = vim.o.shell
}

require("telescope").load_extension "file_browser"
require("nvim-tree").setup {
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = false, -- Turn into false from true by default
  }
}

vim.g.copilot_assume_mapped = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, 
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


-- Set up lspconfig.
local setup = function(server)
  server.setup {
    autostart = true,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }
end
local lspconfig = require('lspconfig')
setup(require('ionide'))

require'lspconfig'.purescriptls.setup {
  -- Your personal on_attach function referenced before to include
  -- keymaps & other ls options
  autostart = true,
  on_attach = on_attach,
  settings = {
    purescript = {
      addSpagoSources = true, -- e.g. any purescript language-server config here
      censorWarnings = {
        "ImplicitQualifiedImport",
        "WildcardInferredType",
        "ScopeShadowing"
      }
    }
  },
  flags = {
    debounce_text_changes = 150,
  }
}

require('nvim-lightbulb').setup({autocmd = {enabled = true}})

-- vim.lsp.set_log_level("debug")

EOF

" let g:deoplete#enable_at_startup = 1
" 
" Required: to be used with nvim-cmp.
"
let g:fsharp#lsp_auto_setup = 0
let g:fsharp#exclude_project_directories = ['paket-files']
" let g:fsharp#enable_reference_code_lens = 0
" let g:fsharp#lsp_codelens = 0
" let g:fsharp#linter = 0

let g:purescript_disable_indent = 1
let g:purescript_unicode_conceal_enable = 0


" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
"
"
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



