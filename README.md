# floating-terminal.nvim

Minimal floating terminal plugin for Neovim.  
Exposes a single command (`vim.cmd.FloatingTerminal`) for toggling the window.

<img width="1440" height="850" alt="floating-terminal" src="https://github.com/user-attachments/assets/20aa9d2c-be02-48e7-9ae1-63279de6f7fd" />

## Installation

Install the usual way using your favourite package manager:
<details>
  <summary>lazy.nvim</summary>

```lua
{
    "Beacon6/floating-terminal.nvim",
    config = function()
        local floating_terminal = require("floating-terminal")
        floating_terminal:setup()

        vim.keymap.set({ "n", "t" }, "`", vim.cmd.FloatingTerminal)
    end
}
```
</details>

## Configuration

You can override the default configuration in the `setup()` method.
<details>
  <summary>Default configuration</summary>

```lua
---@class (exact) Config
---@field width_factor  number   | nil Percentage of screen width
---@field height_factor number   | nil Percentage of screen height
---@field border        Border   | nil Window border style
---@field title         Label    | nil Window title text
---@field title_pos     Position | nil Window title position
---@field footer        Label    | nil Window footer text
---@field footer_pos    Position | nil Window footer position
local config = {
    width_factor  = 0.8,
    height_factor = 0.8,
    border        = vim.o.winborder,
    title         = "",
    title_pos     = "left",
    footer        = "",
    footer_pos    = "left"
}
```
</details>
