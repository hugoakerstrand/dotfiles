-- lua/plugins/rose-pine.lua
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    opts = {
      variant = "moon",
      dark_variant = "moon",
      styles = { transparency = true },
      highlight_groups = {
        Normal = { bg = "none" },
        NormalFloat = { bg = "none" },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd("colorscheme rose-pine")
    end,
  },
}
