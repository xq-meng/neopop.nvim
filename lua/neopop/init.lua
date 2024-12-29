local M = {}

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

function M.show_menu()
    local cursor_word = vim.fn.expand('<cword>')
    if not cursor_word or cursor_word == "" then
        vim.notify("No variable under the cursor!")
        return
    end

    local menu_content = {}
    for _, item in ipairs(menu_items) do
        -- table.insert(menu_content, item[1] .. " - " .. item[2])
        -- table.insert(menu_content, item[1])
        if item[2] and item[2] ~= '' then
            table.insert(menu_content, string.format("%-22s[%s]", item[1], item[2]))
        else
            table.insert(menu_content, string.format("%-22s", item[1]))
        end
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, menu_content)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'cursor',
        row = 1,
        col = 1,
        width = 26,
        height = #menu_content,
        style = 'minimal',
        border = 'rounded',
    })

    -- cursor select.
    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
        noremap = true,
        silent = true,
        callback = function()
            local cursor = vim.api.nvim_win_get_cursor(win)
            vim.api.nvim_win_close(win, true)
            if menu_items[cursor[1]][3] then
                menu_items[cursor[1]][3]()
            end
        end
    })

    -- shortcut.
    for _, item in ipairs(menu_items) do
        if item[2] and item[2] ~= '' and item[3] then
            vim.api.nvim_buf_set_keymap(buf, 'n', item[2], '', {
                noremap = true,
                silent = true,
                callback = function()
                    vim.api.nvim_win_close(win, true)
                    item[3]()
                end
            })
        end
    end

    -- close menu.
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', {
        noremap = true,
        silent = true,
        callback = function()
            vim.api.nvim_win_close(win, true)
        end
    })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
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
