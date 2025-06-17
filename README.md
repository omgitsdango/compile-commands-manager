# compile-commands-manager

## Overview
`compile-commands-manager` is a Neovim plugin designed to help developers manage their `compile_commands.json` file efficiently. This plugin allows users to add or modify compilation commands directly from within Neovim, ensuring that all necessary defines are included for proper code highlighting and completion.

## Features
- Intelligently add or modify entries in the `compile_commands.json` file.
- Handles existing entries by merging defines instead of creating duplicates.
- Only affects the current file, not all entries in the compilation database.
- Prevents duplicate defines from being added to the same file.
- Customizable configuration options to tailor the plugin's behavior.
- Key mappings for quick access to commands.
- Utility functions for reading and writing to the `compile_commands.json` file.

## Installation
To install the plugin, you can use your preferred plugin manager. For example, if you are using `lazy.nvim`, add the following line to your configuration:

```lua
require('lazy').setup({
    'omgitsdango/compile-commands-manager'
})
```

## Usage
Once installed, you can use the following commands to manage your `compile_commands.json`:

- `:AddDefine <define>` - Adds a new define to the current file's compilation command. If an entry for the current file already exists, the define is merged into the existing entry. If the define already exists, it won't be duplicated.
- `:RemoveDefine <define>` - Removes a define from the current file's compilation command.

You can also customize key mappings in your `init.lua` or by calling the setup function:

```lua
require('compile-commands-manager').setup({
    compile_commands_path = "build/compile_commands.json",  -- Custom path
})
```

### Key Mappings
- `<leader>cca` - Prompts to add a define (`:AddDefine `)
- `<leader>ccr` - Prompts to remove a define (`:RemoveDefine `)

## Configuration
You can customize the behavior of the plugin by calling the setup function with options:

```lua
require('compile-commands-manager').setup({
    compile_commands_path = "build/compile_commands.json",  -- Custom path to compile_commands.json
})
```

Available configuration options:
- `compile_commands_path` - Specify the path to your `compile_commands.json` file (default: "compile_commands.json")

### Legacy Configuration
The plugin also supports legacy global variables for backward compatibility:
- `g:ccm_command_file` - Specify the path to your `compile_commands.json` file.
- `g:ccm_auto_update` - Enable or disable automatic updates to the `compile_commands.json` file.

## Example
To add a define for the current file, simply run:

```
:AddDefine MY_DEFINE
```

This will:
1. Check if an entry for the current file already exists in `compile_commands.json`
2. If it exists, add the define to that entry (if not already present)
3. If no entry exists, create a new entry with the define
4. Prevent duplicate defines from being added

To remove a define:

```
:RemoveDefine MY_DEFINE
```

This will remove the specified define only from the current file's entry, leaving other files' entries unchanged.

## Contributing
If you would like to contribute to the project, feel free to submit a pull request or open an issue for any bugs or feature requests.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.
