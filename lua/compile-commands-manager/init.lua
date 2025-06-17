local M = {}

function M.setup(opts)
    -- Load configuration
    require('compile-commands-manager.config').setup(opts)

    -- Load commands
    local commands = require('compile-commands-manager.commands')    -- Set up key mappings for cursor-based workflow
    vim.api.nvim_set_keymap('n', '<leader>cca', '<cmd>lua require("compile-commands-manager.commands").add_define_cursor()<CR>', { noremap = true, silent = true, desc = 'Add define under cursor to compile_commands.json' })
    vim.api.nvim_set_keymap('n', '<leader>ccr', '<cmd>lua require("compile-commands-manager.commands").remove_define_cursor()<CR>', { noremap = true, silent = true, desc = 'Remove define under cursor from compile_commands.json' })

    -- Keep the original prompt-based commands available as well
    vim.api.nvim_set_keymap('n', '<leader>ccA', ':AddDefine ', { noremap = true, silent = false, desc = 'Add define to compile_commands.json (prompt)' })
    vim.api.nvim_set_keymap('n', '<leader>ccR', ':RemoveDefine ', { noremap = true, silent = false, desc = 'Remove define from compile_commands.json (prompt)' })    -- Expose functions for direct use
    M.add_define = commands.add_define
    M.remove_define = commands.remove_define
    M.add_define_cursor = commands.add_define_cursor
    M.remove_define_cursor = commands.remove_define_cursor
end

return M
