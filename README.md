# 🔧 compile-commands-manager

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Neovim](https://img.shields.io/badge/Neovim-0.8+-green.svg)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Made%20with-Lua-blue.svg)](https://lua.org)

> A smart Neovim plugin for effortlessly managing your `compile_commands.json` file

## 🎯 Overview

`compile-commands-manager` is a Neovim plugin designed to help developers manage their `compile_commands.json` file efficiently. This plugin allows users to add or modify compilation commands directly from within Neovim, ensuring that all necessary defines are included for proper code highlighting and completion.

Perfect for C/C++ developers who need to quickly add preprocessor defines for better LSP support and code intelligence.

## ✨ Features

- 🎯 **Cursor-based workflow** - Just place cursor on a word and hit a keybinding
- 🧠 **Intelligent merging** - Handles existing entries by merging defines instead of creating duplicates
- 📁 **File-specific** - Only affects the current file, not all entries in the compilation database
- 🚫 **Duplicate prevention** - Prevents duplicate defines from being added to the same file
- ⚙️ **Customizable** - Flexible configuration options to tailor the plugin's behavior
- ⌨️ **Quick access** - Convenient key mappings for rapid workflow
- 🛠️ **Robust** - Utility functions for safe reading and writing to the `compile_commands.json` file

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommended)

```lua
{
  "omgitsdango/compile-commands-manager",
  event = "VeryLazy",
  config = function()
    require('compile-commands-manager').setup({
      compile_commands_path = "compile_commands.json", -- or your custom path
    })
  end,
}
```

### Using other plugin managers

<details>
<summary>📋 Click to expand other installation methods</summary>

#### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use {
  'omgitsdango/compile-commands-manager',
  config = function()
    require('compile-commands-manager').setup()
  end
}
```

#### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'omgitsdango/compile-commands-manager'
```

#### Manual Installation
```bash
git clone https://github.com/omgitsdango/compile-commands-manager.git ~/.local/share/nvim/site/pack/plugins/start/compile-commands-manager
```

</details>

## 🚀 Usage

### 📝 Commands

- **`:AddDefine <define>`** - Adds a new define to the current file's compilation command
- **`:RemoveDefine <define>`** - Removes a define from the current file's compilation command

### ⌨️ Key Mappings

#### 🎯 Cursor-based workflow (recommended)
> Place your cursor on any word and use these shortcuts

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>cca` | Add define | Adds the word under cursor as a define |
| `<leader>ccr` | Remove define | Removes the word under cursor as a define |

#### 💬 Prompt-based workflow
> Traditional command-line approach

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>ccA` | Add define (prompt) | Prompts you to type the define name |
| `<leader>ccR` | Remove define (prompt) | Prompts you to type the define name to remove |

### 🎬 Workflow Examples

#### 🎯 Cursor-based (recommended)
```
1. 📍 Place your cursor on any word (e.g., DEBUG_MODE)
2. ⌨️  Press <leader>cca to add it as a define
3. ⌨️  Press <leader>ccr to remove it as a define
```

#### 💬 Prompt-based
```
1. ⌨️  Press <leader>ccA and type the define name
2. ⌨️  Press <leader>ccR and type the define name to remove
```

## ⚙️ Configuration

### 🛠️ Basic Setup

```lua
require('compile-commands-manager').setup({
    compile_commands_path = "build/compile_commands.json",  -- Custom path
})
```

### 📋 Available Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `compile_commands_path` | `string` | `"compile_commands.json"` | Path to your compile_commands.json file |

### 📍 File Location Examples

<details>
<summary>🗂️ Click to see different path configurations</summary>

#### Project root (default)
```lua
require('compile-commands-manager').setup({
    compile_commands_path = "compile_commands.json"
})
```

#### Build directory
```lua
require('compile-commands-manager').setup({
    compile_commands_path = "build/compile_commands.json"
})
```

#### Absolute path
```lua
require('compile-commands-manager').setup({
    compile_commands_path = "/absolute/path/to/your/project/compile_commands.json"
})
```

#### CMake build directory
```lua
require('compile-commands-manager').setup({
    compile_commands_path = "cmake-build-debug/compile_commands.json"
})
```

</details>

### 🔧 Legacy Configuration
> For backward compatibility

The plugin also supports legacy global variables:
- `g:ccm_command_file` - Specify the path to your `compile_commands.json` file
- `g:ccm_auto_update` - Enable or disable automatic updates to the `compile_commands.json` file

## 💡 Example

### 🎯 Quick Start

To add a define for the current file, simply run:

```bash
:AddDefine MY_DEFINE
```

**What happens behind the scenes:**
1. ✅ Check if an entry for the current file already exists in `compile_commands.json`
2. ✅ If it exists, add the define to that entry (if not already present)
3. ✅ If no entry exists, create a new entry with the define
4. ✅ Prevent duplicate defines from being added

### 🗑️ Removing Defines

To remove a define:

```bash
:RemoveDefine MY_DEFINE
```

This will remove the specified define **only** from the current file's entry, leaving other files' entries unchanged.

### 📊 Real-world Example

<details>
<summary>🔍 Click to see a complete example</summary>

**Before:** Empty or non-existent `compile_commands.json`

**Action:** Place cursor on `DEBUG_MODE` in your C++ file and press `<leader>cca`

**After:** `compile_commands.json` gets created/updated:
```json
[
  {
    "directory": "/path/to/your/project",
    "command": "gcc -DDEBUG_MODE main.cpp",
    "file": "/path/to/your/project/main.cpp",
    "arguments": ["gcc", "-DDEBUG_MODE", "main.cpp"]
  }
]
```

**Result:** 🎉 Your LSP now recognizes `DEBUG_MODE` and provides proper syntax highlighting and completion!

</details>

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### 🐛 Found a Bug?
- 📝 [Open an issue](https://github.com/omgitsdango/compile-commands-manager/issues/new) with a clear description
- 🏷️ Use the `bug` label
- 📋 Include steps to reproduce

### 💡 Have a Feature Request?
- 📝 [Open an issue](https://github.com/omgitsdango/compile-commands-manager/issues/new) with the `enhancement` label
- 🎯 Describe your use case and expected behavior

### 🔧 Want to Contribute Code?
1. 🍴 Fork the repository
2. 🌱 Create a feature branch (`git checkout -b feature/amazing-feature`)
3. 💾 Commit your changes (`git commit -m 'Add amazing feature'`)
4. 📤 Push to the branch (`git push origin feature/amazing-feature`)
5. 🔄 Open a Pull Request

### 📋 Development Guidelines
- ✅ Follow existing code style
- 📝 Add documentation for new features
- 🧪 Test your changes thoroughly
- 📜 Update README.md if needed

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**⭐ If this plugin helped you, consider giving it a star!**

Made with ❤️ for the Neovim community

</div>
