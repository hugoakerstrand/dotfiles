local o = vim.opt
vim.g.mapleader = ' '        -- space is the leader key
o.expandtab = true           -- spaces, not tabs
o.shiftwidth = 2             -- 2 spaces per indent level
o.number = true              -- absolute number on the cursor line
o.relativenumber = true      -- relative line numbers for fast jumps
o.ignorecase = true          -- search is case-insensitive by default
o.smartcase = true           -- case-sensitive only if you type a capital
o.clipboard = 'unnamedplus'  -- share the system clipboard
o.scrolloff = 16             -- keep cursor away from the screen edge
o.undofile = true            -- persistent undo across sessions

-- Insert the native R pipe |>, mirroring RStudio/Positron's pipe shortcut.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'r', 'rmd', 'quarto' },
  callback = function(args)
    vim.keymap.set('i', '<M-p>', ' |> ', { buffer = args.buf, desc = 'Insert |> pipe' })
  end,
})
