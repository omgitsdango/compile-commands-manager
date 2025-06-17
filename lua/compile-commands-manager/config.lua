local M = {}

M.default_config = {
    compile_commands_path = "compile_commands.json",
    defines = {},
}

M.config = vim.deepcopy(M.default_config)

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.default_config, opts or {})
end

M.set_compile_commands_path = function(path)
    M.config.compile_commands_path = path
end

M.add_define = function(define)
    table.insert(M.config.defines, define)
end

M.get_defines = function()
    return M.config.defines
end

M.get_compile_commands_path = function()
    return M.config.compile_commands_path
end

return M
