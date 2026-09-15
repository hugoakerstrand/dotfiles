return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require('lspconfig').r_language_server.setup({
        capabilities = capabilities,
        cmd = { 'R', '--no-echo', '-e', 'languageserver::run()' },
        -- Default root_dir falls back to $HOME when no .git is found upward,
        -- which makes languageserver try to index the whole home directory
        -- and hang on every request. Never go further up than an R project
        -- marker, or the file's own directory.
        root_dir = function(fname)
          local markers = vim.fs.find(
            { '.git', 'DESCRIPTION', '.Rproj.user', '_targets.R' },
            { path = fname, upward = true }
          )[1]
          return markers and vim.fs.dirname(markers) or vim.fs.dirname(fname)
        end,
        -- languageserver sends malformed cancellation responses (result + error
        -- in the same message), which trips Neovim's strict JSON-RPC validation
        -- and unconditionally prints via Client:write_error before any on_error
        -- hook runs. Patch write_error on the instance to swallow just this code.
        -- https://github.com/REditorSupport/languageserver/issues/766
        on_init = function(client)
          local write_error = client.write_error
          client.write_error = function(self, code, err)
            if code == vim.lsp.rpc.client_errors.INVALID_SERVER_MESSAGE then
              return
            end
            return write_error(self, code, err)
          end
        end,
      })

      -- vim.lsp.buf.hover() does nothing visible on an empty result, which is
      -- indistinguishable from a hung/broken server. Report both explicitly.
      local function hover_with_feedback()
        local bufnr = vim.api.nvim_get_current_buf()
        local params = vim.lsp.util.make_position_params(0, 'utf-16')
        local responded = false
        vim.lsp.buf_request(bufnr, 'textDocument/hover', params, function(err, result, ctx, config)
          responded = true
          if err then
            vim.notify('hover error: ' .. vim.inspect(err), vim.log.levels.WARN)
            return
          end
          local contents = result and result.contents
          local empty = not contents
            or (type(contents) == 'string' and contents == '')
            or (type(contents) == 'table' and vim.tbl_isempty(contents))
          if empty then
            vim.notify('No hover info at cursor', vim.log.levels.INFO)
            return
          end
          vim.lsp.handlers['textDocument/hover'](err, result, ctx, config)
        end)
        vim.defer_fn(function()
          if not responded then
            vim.notify('Hover request timed out (no response after 10s)', vim.log.levels.WARN)
          end
        end, 10000)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'K', hover_with_feedback, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },
}
