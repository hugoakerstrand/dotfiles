return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local parsers = { 'r', 'rnoweb', 'yaml', 'markdown', 'markdown_inline', 'python', 'lua' }
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'r', 'rmd', 'quarto', 'yaml', 'markdown', 'python', 'lua' },
        callback = function() vim.treesitter.start() end,
      })
    end,
  },
}
