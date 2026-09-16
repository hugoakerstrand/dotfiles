-- Save by pressing Escape
-- vim.keymap.set('n', '<Esc>', 'w<CR>', { desc = 'Save' })
-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])

-- R assignment operator, RStudio-style (Alt+-)
vim.keymap.set('i', '<M-->', ' <- ', { desc = 'Insert R assignment operator' })
