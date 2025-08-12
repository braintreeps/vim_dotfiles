# LSP Setup and Configuration Guide

This guide explains how Language Server Protocol (LSP) works in this Neovim config and how to customize it for your needs.

## What is LSP?

LSP (Language Server Protocol) is what makes Neovim "smart" about your code. It provides:
- **Syntax highlighting** and error detection
- **Go to definition** and find references
- **Auto-completion** and code suggestions
- **Refactoring tools** like rename and code actions
- **Real-time error checking** as you type

Think of it as having a programming language expert looking over your shoulder, helping you write better code.

## Currently Supported Languages

This config comes pre-configured with LSP support for:

- **Bash/Shell scripts** (`bashls`)
- **Lua** (`lua_ls`) - for Neovim configuration
- **Ruby** (`ruby_lsp`) - for Ruby/Rails development

## How It Works

### Automatic Installation
When you first open a file in a supported language, the LSP server is automatically:
1. Downloaded and installed via [Mason](https://github.com/mason-org/mason.nvim)
2. Configured with sensible defaults
3. Started and connected to your file

### Manual Management
- **`:Mason`** / **`<Leader>cm`** - Open Mason to manage language servers
- **`:LspInfo`** - See which servers are running for current file

## Adding New Languages

1. Open Mason: `<Leader>cm` or `:Mason`
2. Find your language server (press `/` to search)
3. Press `i` to install
4. Add any custom configuration for the server (optional)

### LSP Server Configuration
Create or open `~/.config/nvim/lua/personal/plugins/lsp.lua` and update it to look like the following:

```lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        your_new_server_name_here = {
          -- add any custom config for your server here
          -- (or leave empty to use defaults)
        },
        -- other custom servers...
      }
    },
  }
}
```
> [!NOTE]
> If you think your new LSP server would be useful for others and should be a Braintree default LSP server, feel free to open a PR that adds it to the list of default LSP servers in [lua/config/lsp.lua](https://github.com/PayPal-Braintree/neovim-dotfiles/blob/8e9464f285ba7893f7924be30c160ba1b92cd9a9/lua/config/lsp.lua#L5)

### Popular Language Servers
- **JavaScript/TypeScript**: `tsserver` or `ts_ls`
- **Python**: `pyright` or `pylsp`
- **Go**: `gopls`
- **Rust**: `rust_analyzer`
- **Java**: `jdtls`
- **C/C++**: `clangd`
- **HTML/CSS**: `html`, `cssls`
- **JSON**: `jsonls`

## Configuration Options

### Diagnostics (Error Display)
These settings currently live in `lua/plugins/lsp.lua` and can also be customized in your own `lua/personal/plugins/lsp.lua` to your liking:
```lua
-- This `diagnostics` key lives at the same level as `servers`, just under `opts` for the "neovim/nvim-lspconfig" plugin
diagnostics = {
  severity_sort = true,           -- Show errors before warnings
  float = {
    border = "rounded",         -- Rounded popup borders
    source = "if_many"          -- Show source if multiple available
  },
  underline = {
    severity = vim.diagnostic.severity.ERROR  -- Only underline errors
  },
}
```

### Server-Specific Settings
Example for Lua language server:
```lua
-- Again, this config is directly under `opts` for the "neovim/nvim-lspconfig" plugin
servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          unusedLocalExclude = { "_*" },  -- Allow unused vars starting with _
        },
        workspace = {
          checkThirdParty = false,        -- Don't check third-party libs
        },
      },
    },
  },
},
```

## Customizing Keymaps

All LSP keymaps are defined in `lua/plugins/lsp.lua`. To customize them, add your own `keymap` section to the `opts` for `"neovim/nvim-lspconfig"`:

```lua
opts = {
    keymap = {
        go_to_definition = "gd",        -- Change this to customize
        hover = "K",                    -- Documentation popup
        lsp_rename = "<Leader>cr",      -- Rename symbol
        lsp_code_action = "<Leader>ca", -- Show fixes/actions
        -- ... other keymaps
    },
}
```

## Troubleshooting

### LSP Not Working?
1. Check if server is installed: `<Leader>cm` and make sure your server is in the "Installed" section
2. Check if server is running: `:LspInfo`
3. Restart LSP: `:LspRestart`
4. Check LSP logs for issues: `:LspLog`

### Server Won't Install?
1. Check internet connection
2. Try installing manually: `<Leader>cm` → find server → press `i`
3. Check Mason logs: `:MasonLog`

### Wrong Language Detection?
1. Check file extension is correct (`.rb` for Ruby, `.lua` for Lua, etc.)
2. Force file type: `:set filetype=ruby`

### Performance Issues?
1. Check LSP logs with `:LspLog`
2. Turn off LSP with `:LspStop`
3. Disable problematic LSP servers with `enabled = false` in `lua/personal/plugins/lsp.lua`

## Advanced Configuration

### Custom Server Setup
For servers that need special configuration, you can add a setup function to your `lua/personal/plugins/lsp.lua`:
```lua
servers = {
  your_new_server_name_here = {
    setup = function(server, server_opts)
      -- Run whatever lua code you need to run here
    end
  }
}
```
Or if you want to run a setup function for any LSP server that doesn't have its own explicit setup function, you can configure one like so:
```lua
servers = {
  ["*"] = {
    setup = function(server, server_opts)
      -- This will run for any configured server without its own `setup` function
    end
  }
}
```

## Learning More

- **Mason documentation**: `:help mason.nvim`
- **LSP documentation**: `:help lsp`
- **Available servers**: [Mason registry](https://mason-registry.dev/registry/list)
- **Server configs**: [nvim-lspconfig server docs](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)

## Quick Reference

| Action | Keymap | Description |
|--------|--------|-------------|
| Manage servers | `<Leader>cm` or `:Mason` | Open Mason |
| Check status | `:LspInfo` | See running servers |
| Restart LSP | `:LspRestart` | Restart all servers |
| Stop LSP | `:LspStop` | Stop LSP servers |
| Mason logs | `:MasonLog` | Debug installation issues |
| LSP logs | `:LspLog` | Debug LSP issues |
