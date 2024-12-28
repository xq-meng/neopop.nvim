local M = {}

local telescope = require('telescope.builtin')
local gitsigns = require('gitsigns')

function M.choice(x)
    -- LSP
    if x == 'Reference' then
        telescope.lsp_references()
        -- vim.api.nvim_command("Telescope lsp_references")
    elseif x == 'Definition' then
        telescope.lsp_definitions()
        -- vim.api.nvim_command("Telescope lsp_definitions")
    elseif x == 'Implementation' then
        telescope.lsp_implementations()
        -- vim.api.nvim_command("Telescope lsp_implementations")
    elseif x == 'Declaration' then
        vim.lsp.buf.declaration()
    -- Gitsign
    elseif x == 'Preview Git Changes' then
        gitsigns.preview_hunk()
    elseif x == 'Reset Git Changes' then
        gitsigns.reset_hunk()
    end
end

function M.show_menu()
    local cursor_word = vim.fn.expand('<cword>')
    if not cursor_word or cursor_word == "" then
        vim.notify("No variable under the cursor!")
        return
    end

    local menu_items = {
        {"Reference", ""},
        {"Definition", ""},
        {"Implementation", ""},
        {"Declaration", ""},
        {"--------------------", ""},
        {"Preview Git Changes", ""},
        {"Reset Git Changes", ""},
    }
    local menu_content = {}
    for _, item in ipairs(menu_items) do
        -- table.insert(menu_content, item[1] .. " - " .. item[2])
        table.insert(menu_content, item[1])
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu_content)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'cursor',
        row = 1,
        col = 1,
        width = 20,
        height = #menu_content,
        style = 'minimal',
        border = 'rounded',
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
        noremap = true,
        silent = true,
        callback = function()
            local cursor = vim.api.nvim_win_get_cursor(win)
            local choice = menu_items[cursor[1]]
            vim.api.nvim_win_close(win, true)
            M.choice(choice[1])
        end
    })

    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', {
        noremap = true,
        silent = true,
        callback = function()
            vim.api.nvim_win_close(win, true)
        end
    })
end

function M.setup()

end

M.setup()

return M
