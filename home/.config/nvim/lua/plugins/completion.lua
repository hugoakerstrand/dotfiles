return {
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { preset = 'super-tab' },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = true },
        trigger = { show_in_snippet = false },
      },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    },
  },
}
