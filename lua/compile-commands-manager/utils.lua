local M = {}

function M.read_compile_commands(file_path)
    local file = io.open(file_path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return vim.json.decode(content)
end

function M.write_compile_commands(file_path, commands)
    local file = io.open(file_path, "w")
    if not file then return false end
    file:write(vim.json.encode(commands))
    file:close()
    return true
end

function M.add_define_to_commands(file_path, define, source_file)
    local commands = M.read_compile_commands(file_path) or {}
    local absolute_source_file = vim.fn.fnamemodify(source_file, ":p")

    -- Find existing entry for the source file
    local found_entry = false
    for _, command in ipairs(commands) do
        if command.file == absolute_source_file then
            found_entry = true
            -- Check if define already exists
            local define_flag = "-D" .. define
            local already_exists = false

            if command.arguments then
                for _, arg in ipairs(command.arguments) do
                    if arg == define_flag then
                        already_exists = true
                        break
                    end
                end

                -- Add define if it doesn't exist
                if not already_exists then
                    table.insert(command.arguments, define_flag)
                end
            else
                -- Create arguments array if it doesn't exist
                command.arguments = { "gcc", define_flag, vim.fn.fnamemodify(absolute_source_file, ":t") }
            end

            -- Also update the command string for compatibility
            if not already_exists then
                if command.command then
                    if not string.find(command.command, define_flag) then
                        command.command = command.command .. " " .. define_flag
                    end
                else
                    command.command = "gcc " .. define_flag .. " " .. vim.fn.fnamemodify(absolute_source_file, ":t")
                end
            end
            break
        end
    end

    -- If no entry found, create a new one
    if not found_entry then
        local new_entry = {
            directory = vim.fn.fnamemodify(absolute_source_file, ":h"),
            command = "gcc -D" .. define .. " " .. vim.fn.fnamemodify(absolute_source_file, ":t"),
            file = absolute_source_file,
            arguments = { "gcc", "-D" .. define, vim.fn.fnamemodify(absolute_source_file, ":t") }
        }
        table.insert(commands, new_entry)
    end

    return M.write_compile_commands(file_path, commands)
end

function M.remove_define_from_commands(file_path, define, source_file)
    local commands = M.read_compile_commands(file_path) or {}
    local absolute_source_file = vim.fn.fnamemodify(source_file, ":p")

    -- Find existing entry for the source file
    local found_entry = false
    local removed_count = 0

    for _, command in ipairs(commands) do
        if command.file == absolute_source_file then
            found_entry = true
            if command.arguments then
                local define_flag = "-D" .. define
                for i = #command.arguments, 1, -1 do
                    if command.arguments[i] == define_flag then
                        table.remove(command.arguments, i)
                        removed_count = removed_count + 1
                    end
                end
            end

            -- Also update the command string for compatibility
            if command.command and removed_count > 0 then
                local define_flag = "-D" .. define
                command.command = command.command:gsub("%s*" .. vim.pesc(define_flag), "")
            end
            break
        end
    end

    if found_entry and removed_count > 0 then
        return M.write_compile_commands(file_path, commands)
    end

    return found_entry
end

return M
