local M = {}

function M.setup(opts)
    -- Load configuration
    require('compile-commands-manager.config').setup(opts)

    -- Load commands
    local commands = require('compile-commands-manager.commands')

    -- Set up key mappings
    vim.api.nvim_set_keymap('n', '<leader>cca', ':AddDefine ', { noremap = true, silent = false, desc = 'Add define to compile_commands.json' })
    vim.api.nvim_set_keymap('n', '<leader>ccr', ':RemoveDefine ', { noremap = true, silent = false, desc = 'Remove define from compile_commands.json' })

    -- Expose functions for direct use
    M.add_define = commands.add_define
    M.remove_define = commands.remove_define
end

return M
