-- This file is the entry point for the compile-commands-manager plugin.
-- It requires the necessary modules and sets up the commands and key mappings.

local commands = require('compile-commands-manager.commands')

-- Set up commands
vim.api.nvim_create_user_command('AddDefine', function(opts)
    commands.add_define(opts.args)
end, { nargs = 1, desc = 'Add a define to the compile_commands file for the current file' })

vim.api.nvim_create_user_command('RemoveDefine', function(opts)
    commands.remove_define(opts.args)
end, { nargs = 1, desc = 'Remove a define from the compile_commands file for the current file' })
