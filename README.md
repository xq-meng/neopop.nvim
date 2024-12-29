# neopop.nvim

```
local telescope = require('telescope.builtin')
local gitsigns = require('gitsigns')

local menu_items = {
    {"Reference", "r", telescope.lsp_references},
    {"Definition", "d", telescope.lsp_definitions},
    {"Implementation", "i", telescope.lsp_implementations},
    {"Declaration", "D", vim.lsp.buf.declaration},
    {"--------------------", ""},
    {"Preview Git Changes", "P", gitsigns.preview_hunk},
    {"Reset Git Changes", "R", gitsigns.reset_hunk},
}

require('xqmeng/neopop.nvim').setup(menu_items)
```
