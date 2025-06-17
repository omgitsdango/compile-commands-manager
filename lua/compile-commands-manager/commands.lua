local M = {}
local config = require('compile-commands-manager.config')

function M.add_define_cursor()
    local define = vim.fn.expand("<cword>")
    if define == "" then
        print("No word under cursor")
        return
    end
    M.add_define(define)
end

function M.remove_define_cursor()
    local define = vim.fn.expand("<cword>")
    if define == "" then
        print("No word under cursor")
        return
    end
    M.remove_define(define)
end

function M.add_define(define)
    local current_file = vim.fn.expand("%:p")  -- Get absolute path of current file
    local file_path = config.get_compile_commands_path() or "compile_commands.json"
    local compile_commands = {}

    -- Read the existing compile_commands.json
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*a")
        file:close()

        -- Only try to decode if content is not empty
        if content and content:match("%S") then
            local success, result = pcall(vim.fn.json_decode, content)
            if success then
                compile_commands = result
            else
                print("Warning: Invalid JSON in " .. file_path .. ", starting with empty compile commands")
                compile_commands = {}
            end
        else
            print("Warning: Empty " .. file_path .. ", starting with empty compile commands")
            compile_commands = {}
        end
    else
        print("Note: " .. file_path .. " doesn't exist, will create new one")
    end

    -- Find existing entry for current file
    local found_entry = false
    for _, command in ipairs(compile_commands) do
        if command.file == current_file then
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
                    print("Added define '" .. define .. "' to existing entry for " .. vim.fn.fnamemodify(current_file, ":t"))
                else
                    print("Define '" .. define .. "' already exists for " .. vim.fn.fnamemodify(current_file, ":t"))
                end
            else
                -- Create arguments array if it doesn't exist
                command.arguments = { define_flag }
                print("Added define '" .. define .. "' to existing entry for " .. vim.fn.fnamemodify(current_file, ":t"))
            end
            break
        end
    end

    -- If no entry found for current file, create a new one
    if not found_entry then
        local new_entry = {
            directory = vim.fn.fnamemodify(current_file, ":h"),
            command = "gcc -D" .. define .. " " .. vim.fn.fnamemodify(current_file, ":t"),
            file = current_file,
            arguments = { "gcc", "-D" .. define, vim.fn.fnamemodify(current_file, ":t") }
        }        table.insert(compile_commands, new_entry)
        print("Created new entry with define '" .. define .. "' for " .. vim.fn.fnamemodify(current_file, ":t"))
    end

    -- Write the updated compile_commands back to the file
    file = io.open(file_path, "w")
    if file then
        file:write(vim.fn.json_encode(compile_commands))
        file:close()
    else
        print("Could not open compile_commands.json for writing.")
    end
end

function M.remove_define(define)
    local current_file = vim.fn.expand("%:p")  -- Get absolute path of current file
    local file_path = config.get_compile_commands_path() or "compile_commands.json"
    local compile_commands = {}

    -- Read the existing compile_commands.json
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*a")
        file:close()

        -- Only try to decode if content is not empty
        if content and content:match("%S") then
            local success, result = pcall(vim.fn.json_decode, content)
            if success then
                compile_commands = result
            else
                print("Warning: Invalid JSON in " .. file_path .. ", cannot remove define")
                return
            end
        else
            print("Warning: Empty " .. file_path .. ", no defines to remove")
            return
        end
    else
        print("Error: " .. file_path .. " doesn't exist, no defines to remove")
        return
    end

    -- Find and modify the entry for the current file only
    local found_entry = false
    local removed_count = 0

    for _, command in ipairs(compile_commands) do
        if command.file == current_file then
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
            break
        end
    end

    if found_entry then
        if removed_count > 0 then
            print("Removed " .. removed_count .. " instance(s) of define '" .. define .. "' from " .. vim.fn.fnamemodify(current_file, ":t"))
        else
            print("Define '" .. define .. "' not found in entry for " .. vim.fn.fnamemodify(current_file, ":t"))
        end
    else
        print("No entry found for current file: " .. vim.fn.fnamemodify(current_file, ":t"))        return
    end

    -- Write the updated compile_commands back to the file
    file = io.open(file_path, "w")
    if file then
        file:write(vim.fn.json_encode(compile_commands))
        file:close()
    else
        print("Could not open compile_commands.json for writing.")
    end
end

return M
