
call plug#begin()

Plug 'neovim/nvim-lspconfig', {'tag' : '*'}
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp', {'tag' : '*'}

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'purescript-contrib/purescript-vim', {'tag' : '*'}

call plug#end()

let mapleader = ","
map K <cmd>lua vim.lsp.buf.hover()<cr>
map gd <cmd>lua vim.lsp.buf.definition()<cr>
map <leader>. <cmd>lua vim.lsp.buf.code_action()<cr>

lua <<EOF

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

require'lspconfig'.purescriptls.setup {
  -- Your personal on_attach function referenced before to include
  -- keymaps & other ls options
  autostart = true,
  on_attach = on_attach,
  settings = {
    purescript = {
      addSpagoSources = true, -- e.g. any purescript language-server config here
    }
  },
  flags = {
    debounce_text_changes = 150,
  }
}

EOF

